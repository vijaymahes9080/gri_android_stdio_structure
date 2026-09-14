package com.example.backend

import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.engine.cio.CIO
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.request.get
import io.ktor.client.request.post
import io.ktor.client.request.setBody
import io.ktor.http.ContentType
import io.ktor.http.contentType
import io.ktor.serialization.gson.gson
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class GriKtorClient(
  private val baseUrl: String = "http://127.0.0.1:8080/api"
) {
  private val client by lazy {
    HttpClient(CIO) {
      install(ContentNegotiation) {
        gson()
      }
    }
  }

  suspend fun checkHealth(): Result<ServerHealthResponse> = withContext(Dispatchers.IO) {
    runCatching {
      client.get("$baseUrl/health").body<ServerHealthResponse>()
    }
  }

  suspend fun login(role: String): Result<LoginResponse> = withContext(Dispatchers.IO) {
    runCatching {
      client.post("$baseUrl/auth/login") {
        contentType(ContentType.Application.Json)
        setBody(LoginRequest(identifier = "user_$role", role = role))
      }.body<LoginResponse>()
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
