package com.example.backend

import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.engine.cio.CIO
import io.ktor.client.plugins.HttpSend
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.request.get
import io.ktor.client.request.post
import io.ktor.client.request.setBody
import io.ktor.http.ContentType
import io.ktor.http.HttpHeaders
import io.ktor.http.HttpStatusCode
import io.ktor.http.contentType
import io.ktor.serialization.gson.gson
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class GriKtorClient(
  private val baseUrl: String = "http://127.0.0.1:8080/api",
  initialAccessToken: String? = null,
  initialRefreshToken: String? = null,
  private val onTokenRefreshed: ((String) -> Unit)? = null
) {
  var accessToken: String? = initialAccessToken
  var refreshToken: String? = initialRefreshToken

  private val client by lazy {
    HttpClient(CIO) {
      install(ContentNegotiation) {
        gson()
      }
      install(HttpSend) {
        intercept { context ->
          val token = accessToken
          if (!token.isNullOrBlank() && !context.url.encodedPath.contains("/auth/login")) {
            context.headers.remove(HttpHeaders.Authorization)
            context.headers.append(HttpHeaders.Authorization, "Bearer $token")
          }

          val originalCall = execute(context)

          if (originalCall.response.status == HttpStatusCode.Unauthorized &&
              !refreshToken.isNullOrBlank() &&
              !context.url.encodedPath.contains("/auth/refresh") &&
              !context.url.encodedPath.contains("/auth/login")
          ) {
            val refreshed = performTokenRefresh()
            if (refreshed) {
              val newToken = accessToken
              if (!newToken.isNullOrBlank()) {
                context.headers.remove(HttpHeaders.Authorization)
                context.headers.append(HttpHeaders.Authorization, "Bearer $newToken")
                execute(context)
              } else {
                originalCall
              }
            } else {
              originalCall
            }
          } else {
            originalCall
          }
        }
      }
    }
  }

  private suspend fun performTokenRefresh(): Boolean {
    val rToken = refreshToken ?: return false
    return try {
      val response = client.post("$baseUrl/auth/refresh") {
        contentType(ContentType.Application.Json)
        setBody(mapOf("refreshToken" to rToken))
      }
      if (response.status == HttpStatusCode.OK) {
        val body: Map<String, Any> = response.body()
        val newAccess = body["accessToken"] as? String
        val newRefresh = body["refreshToken"] as? String
        if (!newAccess.isNullOrBlank()) {
          accessToken = newAccess
          if (!newRefresh.isNullOrBlank()) {
            refreshToken = newRefresh
          }
          onTokenRefreshed?.invoke(newAccess)
          true
        } else {
          false
        }
      } else {
        false
      }
    } catch (e: Exception) {
      false
    }
  }

  suspend fun checkHealth(): Result<ServerHealthResponse> = withContext(Dispatchers.IO) {
    runCatching {
      client.get("$baseUrl/health").body<ServerHealthResponse>()
    }
  }

  suspend fun login(role: String): Result<LoginResponse> = withContext(Dispatchers.IO) {
    runCatching {
      val res = client.post("$baseUrl/auth/login") {
        contentType(ContentType.Application.Json)
        setBody(LoginRequest(identifier = "user_$role", role = role))
      }.body<LoginResponse>()
      
      res.token?.let { accessToken = it }
      res
    }
  }

  suspend fun getHallTicket(): Result<HallTicketResponse> = withContext(Dispatchers.IO) {
    runCatching {
      client.get("$baseUrl/examinations/hallticket").body<HallTicketResponse>()
    }
  }

  suspend fun submitGrievance(
    category: String,
    subject: String,
    description: String,
    rollNo: String
  ): Result<String> = withContext(Dispatchers.IO) {
    runCatching {
      val response: Map<String, Any> = client.post("$baseUrl/grievances") {
        contentType(ContentType.Application.Json)
        setBody(GrievanceRequest(category, subject, description, rollNo))
      }.body()
      (response["ticketNumber"] as? String) ?: "TICKET_OK"
    }
  }

  suspend fun triggerSync(): Result<Int> = withContext(Dispatchers.IO) {
    runCatching {
      val response: Map<String, Any> = client.post("$baseUrl/sync").body()
      ((response["syncedCount"] as? Number)?.toInt()) ?: 0
    }
  }

  fun close() {
    client.close()
  }
}
