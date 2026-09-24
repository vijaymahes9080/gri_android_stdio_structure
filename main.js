/**
 * ============================================================================
 * GRI MOBILE PORTAL 2026 — CORE APPLICATION LOGIC & INTERACTION ENGINE
 * Gandhigram Rural Institute (Deemed to be University)
 * ============================================================================
 */

// --- 1. Comprehensive State Store ---
const state = {
  currentRole: 'STUDENT',
  theme: 'dark',
  hasBezel: true,
  currentTab: 'home',
  isSyncing: false,
  offlineQueueCount: 0,
  unreadNotifsCount: 3,

  // Users per role (matches GriRepository.kt)
  users: {
    STUDENT: {
      id: 'usr_student',
      name: 'Srimari Vijay',
      email: 'srimarivijay@gmail.com',
      rollNo: '23MCA042',
      department: 'Computer Science & Applications',
      program: 'Master of Computer Applications (MCA)',
      semester: 'Semester IV (Final Year)',
      cgpa: '8.92',
      attendance: 88.5,
      isHostelite: true,
      hostelName: 'Thamarai Illam (Room 214)',
      busPass: 'Route 1: Dindigul ↔ GRI',
      validThru: '2026-12-31'
    },
    FACULTY: {
      id: 'usr_faculty',
      name: 'Dr. R. Subramanian',
      email: 'r.subramanian@ruraluniv.ac.in',
      rollNo: 'FAC-CS-108',
      department: 'School of Sciences & Rural Technology',
      program: 'Faculty of Computer Science',
      semester: 'Senior Associate Professor',
      cgpa: 'Ph.D. IIT Madras',
      attendance: 96.0,
      isHostelite: false,
      hostelName: 'Staff Quarters Type IV-B',
      busPass: 'University Shuttle',
      validThru: '2030-05-31'
    },
    ADMIN: {
      id: 'usr_admin',
      name: 'GRI Controller of Examinations',
      email: 'coe@ruraluniv.ac.in',
      rollNo: 'ADMIN-GRI-01',
      department: 'Central Administration & Samarth ERP Hub',
      program: 'Administrative Directorate',
      semester: 'Office of the Controller of Examinations',
      cgpa: 'Authorized Statutory Officer',
      attendance: 100.0,
      isHostelite: false,
      hostelName: 'Administrative Secretariat',
      busPass: 'Official Fleet',
      validThru: 'Permanent'
    },
    STAFF: {
      id: 'usr_staff',
      name: 'K. Shanmugasundaram',
      email: 'k.shanmugam@ruraluniv.ac.in',
      rollNo: 'STF-ADM-042',
      department: 'Finance & Establishment Section',
      program: 'Administrative Staff',
      semester: 'Section Officer / Superintendent',
      cgpa: 'Cadre: Group B Non-Teaching',
      attendance: 94.2,
      isHostelite: false,
      hostelName: 'N/A',
      busPass: 'Route 2: Madurai ↔ GRI',
      validThru: '2032-03-31'
    },
    SCHOLAR: {
      id: 'usr_scholar',
      name: 'Ananya Murugan',
      email: 'ananya.m@ruraluniv.ac.in',
      rollNo: '24PHD-ECO-09',
      department: 'Rural Development & Sustainable Agro-Economy',
      program: 'Doctor of Philosophy (Ph.D.)',
      semester: 'Year 2 Research Scholar',
      cgpa: 'UGC JRF Fellow',
      attendance: 92.4,
      isHostelite: true,
      hostelName: 'Kasturba Scholars Hostel',
      busPass: 'Campus Pass',
      validThru: '2028-06-30'
    },
    GUEST: {
      id: 'usr_guest',
      name: 'Gandhigram Visitor',
      email: 'guest@ruraluniv.ac.in',
      rollNo: 'GUEST-2026',
      department: 'Prospective Student / Campus Visitor',
      program: 'Visitor Portal',
      semester: 'Public Access',
      cgpa: 'N/A',
      attendance: 0,
      isHostelite: false,
      hostelName: 'University Guest House',
      busPass: 'Visitor Day Ticket',
      validThru: '2026-12-31'
    }
  },

  // Courses with live attendance calculator data
  courses: [
    { code: 'CS501', title: 'Advanced Cloud Computing', credits: 4, instructor: 'Dr. K. Senthilkumar', schedule: 'Mon, Wed 10:00 AM', attendance: 91, total: 36, attended: 33 },
    { code: 'RD402', title: 'Gandhian Reconstruction & Ethics', credits: 3, instructor: 'Prof. R. Mani', schedule: 'Tue, Thu 11:30 AM', attendance: 84, total: 32, attended: 27 },
    { code: 'CS505', title: 'Distributed Mobile & Web Architectures', credits: 4, instructor: 'Dr. M. Pushpalatha', schedule: 'Mon, Fri 02:00 PM', attendance: 88, total: 34, attended: 30 },
    { code: 'MA301', title: 'Applied Statistical Analytics', credits: 4, instructor: 'Dr. P. Balasubramaniam', schedule: 'Wed, Thu 09:00 AM', attendance: 76, total: 38, attended: 29 },
    { code: 'CA404', title: 'Nai Talim Village Internship Fieldwork', credits: 2, instructor: 'Field Coordinator', schedule: 'Saturday 08:30 AM', attendance: 95, total: 20, attended: 19 }
  ],

  // Examination Hall Ticket Data
  hallTicket: {
    ticketNo: 'HT-2026-NOV-7842',
    examSession: 'End Semester Examinations • Nov / Dec 2026',
    sanadCode: 'SANAD-TN-GRI-2026-98124',
    center: 'Multipurpose Exam Hall - Block B, GRI Main Campus',
    exams: [
      { code: 'CS501', title: 'Advanced Cloud Computing', date: '2026-11-24', session: 'FN 10:00 AM - 01:00 PM', hall: 'Hall 4', desk: 'Desk A-12', reporting: '09:30 AM' },
      { code: 'RD402', title: 'Gandhian Reconstruction & Ethics', date: '2026-11-26', session: 'FN 10:00 AM - 01:00 PM', hall: 'Hall 4', desk: 'Desk A-12', reporting: '09:30 AM' },
      { code: 'CS505', title: 'Distributed Mobile & Web Architectures', date: '2026-11-29', session: 'AN 02:00 PM - 05:00 PM', hall: 'Hall 2', desk: 'Desk B-05', reporting: '01:30 PM' },
      { code: 'MA301', title: 'Applied Statistical Analytics', date: '2026-12-02', session: 'FN 10:00 AM - 01:00 PM', hall: 'Hall 4', desk: 'Desk A-12', reporting: '09:30 AM' }
    ]
  },

  // Bus Transit Routes
  busRoutes: [
    {
      id: 'route_1',
      name: 'Route 1: Dindigul Railway Jn ↔ GRI Main Gate',
      busNo: 'TN-57-N-2418',
      driver: 'M. Murugesan',
      phone: '+91 94431 82410',
      eta: '8 mins',
      progress: 68,
      status: 'Approaching Chinnalapatti Four-Roads'
    },
    {
      id: 'route_2',
      name: 'Route 2: Madurai Periyar Bus Stand ↔ GRI',
      busNo: 'TN-57-N-3102',
      driver: 'S. Palanichamy',
      phone: '+91 98421 95430',
      eta: '22 mins',
      progress: 35,
      status: 'Crossed Vadipatti Toll Plaza'
    },
    {
      id: 'route_3',
      name: 'Route 3: Batlagundu Bus Terminus ↔ GRI',
      busNo: 'TN-57-N-1894',
      driver: 'K. Vellingiri',
      phone: '+91 97880 14209',
      eta: '14 mins',
      progress: 82,
      status: 'Entering University South Gate'
    }
  ],

  // Grievances list
  grievances: [
    {
      id: 'GRI-2026-TKT-8912',
      category: 'Infrastructure & Labs',
      subject: 'High-speed Wi-Fi access point in Computer Science Block Lab 3',
      date: '22 Sep 2026',
      status: 'RESOLVED',
      progress: 100,
      remarks: 'Access Point dual-band router replaced and calibrated by Central Computer Centre.'
    },
    {
      id: 'GRI-2026-TKT-9204',
      category: 'Hostel & Mess',
      subject: 'Drinking water RO plant scheduled maintenance in Thamarai Illam',
      date: '23 Sep 2026',
      status: 'IN_PROGRESS',
      progress: 65,
      remarks: 'Estate maintenance team assigned; filter replacement underway today.'
    }
  ],

  // Circulars
  circulars: [
    {
      id: 'CIR-2026-NOV-01',
      title: 'Samarth@GRI Semester Examination Hall Tickets Released',
      category: 'Examinations',
      date: '24 Sep 2026',
      issuedBy: 'Controller of Examinations',
      urgent: true,
      summary: 'Candidates appearing for Nov/Dec 2026 End Semester Examinations can download verified hall tickets with e-SANAD QR tokens.'
    },
    {
      id: 'CIR-2026-NOV-02',
      title: 'Nai Talim Village Internship Fieldwork Orientation',
      category: 'Academics',
      date: '21 Sep 2026',
      issuedBy: 'Dean of Academic Affairs',
      urgent: false,
      summary: 'Mandatory rural development orientation for postgraduate students at Kasturba Hospital and Gandhigram Seva Ashram.'
    },
    {
      id: 'CIR-2026-NOV-03',
      title: 'e-SANAD Digital Transcripts & Degree Verification Service',
      category: 'Administration',
      date: '18 Sep 2026',
      issuedBy: "Registrar's Secretariat",
      urgent: false,
      summary: 'University degree records and mark transcripts are now integrated with National Academic Depository (NAD) and DigiLocker.'
    }
  ],

  // Sahayak AI messages
  sahayakMessages: [
    {
      isBot: true,
      text: "Vanakkam! I am GRI-Sahayak, your institutional AI guide for The Gandhigram Rural Institute (Deemed to be University). Ask me about Admissions 2026, CBCS courses, examination hall tickets, 75% attendance criteria, hostels, or campus transit.",
      source: 'ruraluniv.ac.in • Official UGC Registry'
    }
  ]
};

// --- 2. Audio & Haptic Feedback ---
class HapticFeedback {
  static click() {
    if (navigator.vibrate) navigator.vibrate(10);
  }
  static success() {
    if (navigator.vibrate) navigator.vibrate([15, 50, 20]);
  }
}

// --- 3. DOM Elements Cache ---
const el = {
  simulatorWrapper: document.getElementById('simulatorWrapper'),
  mobileFrameContainer: document.getElementById('mobileFrameContainer'),
  mobileScreen: document.getElementById('mobileScreen'),
  toggleDeviceFrameBtn: document.getElementById('toggleDeviceFrameBtn'),
  toggleGlobalThemeBtn: document.getElementById('toggleGlobalThemeBtn'),
  themeBtnText: document.getElementById('themeBtnText'),
  quickSyncBtn: document.getElementById('quickSyncBtn'),
  globalRoleSelect: document.getElementById('globalRoleSelect'),
  currentRoleChip: document.getElementById('currentRoleChip'),
  statusClock: document.getElementById('statusClock'),
  bottomNav: document.getElementById('bottomNav'),
  toastContainer: document.getElementById('toastContainer'),
  
  // Modals
  sahayakModal: document.getElementById('sahayakModal'),
  openSahayakBtn: document.getElementById('openSahayakBtn'),
  closeSahayakBtn: document.getElementById('closeSahayakBtn'),
  sahayakChatBody: document.getElementById('sahayakChatBody'),
  sahayakForm: document.getElementById('sahayakForm'),
  sahayakInput: document.getElementById('sahayakInput'),
  sahayakChips: document.getElementById('sahayakChips'),

  hallTicketModal: document.getElementById('hallTicketModal'),
  closeHallTicketBtn: document.getElementById('closeHallTicketBtn'),
  hallTicketView: document.getElementById('hallTicketView'),
  printTicketBtn: document.getElementById('printTicketBtn'),
  doneTicketBtn: document.getElementById('doneTicketBtn'),

  docCenterModal: document.getElementById('docCenterModal'),
  openDocCenterBtn: document.getElementById('openDocCenterBtn'),
  closeDocCenterBtn: document.getElementById('closeDocCenterBtn'),
  btnVerifyHash: document.getElementById('btnVerifyHash'),
  verifyHashInput: document.getElementById('verifyHashInput'),
  verifyResultBanner: document.getElementById('verifyResultBanner'),
  verifyResultText: document.getElementById('verifyResultText'),
  docListContainer: document.getElementById('docListContainer'),

  notifModal: document.getElementById('notifModal'),
  openNotificationsBtn: document.getElementById('openNotificationsBtn'),
  closeNotifBtn: document.getElementById('closeNotifBtn'),
  notifList: document.getElementById('notifList'),
  markAllReadBtn: document.getElementById('markAllReadBtn'),
  unreadNotifCount: document.getElementById('unreadNotifCount'),
  notifBadge: document.getElementById('notifBadge'),

  facultyModal: document.getElementById('facultyModal'),
  closeFacultyBtn: document.getElementById('closeFacultyBtn'),
  facultyModalBody: document.getElementById('facultyModalBody'),

  // Screens
  screenHome: document.getElementById('screenHome'),
  screenAcademics: document.getElementById('screenAcademics'),
  screenCampus: document.getElementById('screenCampus'),
  screenServices: document.getElementById('screenServices'),
  screenAdmin: document.getElementById('screenAdmin')
};

// --- 4. Live Clock Updater ---
function updateClock() {
  const now = new Date();
  let hours = now.getHours();
  const mins = String(now.getMinutes()).padStart(2, '0');
  el.statusClock.textContent = `${hours}:${mins}`;
}
setInterval(updateClock, 1000);
updateClock();

// --- 5. Toast Notification System ---
function showToast(message, type = 'success') {
  HapticFeedback.click();
  const toast = document.createElement('div');
  toast.className = `toast ${type}`;
  toast.innerHTML = `
    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
      ${type === 'success' ? '<path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>' : '<path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/>'}
    </svg>
    <span>${message}</span>
  `;
  el.toastContainer.appendChild(toast);
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(-10px)';
    toast.style.transition = 'all 0.3s';
    setTimeout(() => toast.remove(), 300);
  }, 3500);
}

// --- 6. 3D Card Tilt Interaction Engine ---
function attach3DTiltHandlers() {
  document.querySelectorAll('.tilt-card').forEach(card => {
    card.addEventListener('mousemove', e => {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left - rect.width / 2;
      const y = e.clientY - rect.top - rect.height / 2;
      const rotateX = -(y / (rect.height / 2)) * 6;
      const rotateY = (x / (rect.width / 2)) * 6;
      card.style.transform = `perspective(1000px) rotateX(${rotateX.toFixed(2)}deg) rotateY(${rotateY.toFixed(2)}deg) translateY(-2px)`;
    });
    card.addEventListener('mouseleave', () => {
      card.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg) translateY(0)';
    });
  });
}

// --- 7. Screen Renderers ---

// Screen 1: Home Dashboard
function renderHomeScreen() {
  const u = state.users[state.currentRole] || state.users.STUDENT;
  const isStudent = state.currentRole === 'STUDENT';
  const isAdmin = state.currentRole === 'ADMIN';
  const isFaculty = state.currentRole === 'FACULTY';

  el.screenHome.innerHTML = `
    <!-- 1. Hero Identity Card -->
    <div class="card hero-student-card tilt-card" id="heroStudentCard">
      <div class="hero-profile-row">
        <div class="student-meta-info">
          <h1>${u.name}</h1>
          <div class="student-sub">${u.rollNo} • ${u.program}</div>
          <div class="student-dept">${u.department}</div>
        </div>
        <div class="student-avatar-wrap">
          <img src="/assets/student_avatar.jpg" alt="${u.name}" class="student-avatar-img">
          <span class="hero-badge-live">LIVE</span>
        </div>
      </div>
      <div class="hero-stats-row">
        <div class="mini-stat-col">
          <span class="mini-stat-label">${isStudent ? 'CGPA' : 'Designation'}</span>
          <span class="mini-stat-val highlight">${u.cgpa}</span>
        </div>
        <div class="mini-stat-col">
          <span class="mini-stat-label">Biometric</span>
          <span class="mini-stat-val">${u.attendance}%</span>
        </div>
        <div class="mini-stat-col">
          <span class="mini-stat-label">Status</span>
          <span class="mini-stat-val" style="color: var(--color-success);">Verified</span>
        </div>
      </div>
    </div>

    <!-- 2. Biometric Attendance Pulse Donut (for student/faculty) -->
    <div class="card attendance-widget-card tilt-card">
      <div class="progress-donut-wrap">
        <svg class="donut-svg" viewBox="0 0 72 72">
          <circle class="donut-bg" cx="36" cy="36" r="32"></circle>
          <circle class="donut-fill" cx="36" cy="36" r="32" style="stroke-dashoffset: ${(1 - u.attendance / 100) * 201};"></circle>
        </svg>
        <div class="donut-label-center">
          <span class="donut-percent">${u.attendance}%</span>
          <span class="donut-sub">UGC Safe</span>
        </div>
      </div>
      <div class="attendance-details-col">
        <h3 class="attendance-title">Smart Attendance Ledger</h3>
        <p class="attendance-desc">All registered courses comply with the mandatory 75% CBCS examination threshold.</p>
        <div class="attendance-status-badge">
          <svg viewBox="0 0 24 24" width="12" height="12" fill="currentColor"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
          Biometric Check-in Safe Zone
        </div>
      </div>
    </div>

    <!-- 3. Quick Action Grid -->
    <div class="section-header-row">
      <span class="section-title">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M4 8h4V4H4v4zm6 12h4v-4h-4v4zm-6 0h4v-4H4v4zm0-6h4v-4H4v4zm6 0h4v-4h-4v4zm6-10v4h4V4h-4zm-6 4h4V4h-4v4zm6 6h4v-4h-4v4zm0 6h4v-4h-4v4z"/></svg>
        Quick Institutional Actions
      </span>
    </div>
    <div class="quick-action-grid">
      <button class="action-card-btn" id="btnQuickHallTicket">
        <div class="action-icon-circle">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M22 10V6c0-1.11-.9-2-2-2H4c-1.1 0-1.99.89-1.99 2v4c1.1 0 1.99.9 1.99 2s-.89 2-2 2v4c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2v-4c-1.1 0-2-.9-2-2s.9-2 2-2zm-2-1.53c-1.29.83-2.16 2.27-2.16 3.53 0 1.26.87 2.7 2.16 3.53V18H4v-2.47c1.29-.83 2.16-2.27 2.16-3.53 0-1.26-.87-2.7-2.16-3.53V6h16v2.47z"/></svg>
        </div>
        <span class="action-btn-label">Hall Ticket</span>
      </button>

      <button class="action-card-btn" id="btnQuickGrievance">
        <div class="action-icon-circle">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
        </div>
        <span class="action-btn-label">GRI-Care</span>
      </button>

      <button class="action-card-btn" id="btnQuickBus">
        <div class="action-icon-circle">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 2c-4.42 0-8 .5-8 4v10c0 .88.39 1.67 1 2.22V20c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h8v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1.78c.61-.55 1-1.34 1-2.22V6c0-3.5-3.58-4-8-4zm5.5 13c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm-11 0c-.83 0-1.5-.67-1.5-1.5S5.67 12 6.5 12s1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM18 10H6V7h12v3z"/></svg>
        </div>
        <span class="action-btn-label">Live Transit</span>
      </button>

      <button class="action-card-btn accent" id="btnQuickSahayak">
        <div class="action-icon-circle">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 2a2 2 0 0 1 2 2c0 .74-.4 1.38-1 1.72V7h1a7 7 0 0 1 7 7v1a3 3 0 0 1-3 3h-1.18c-.4.59-1.07 1-1.82 1h-6a2 2 0 0 1-2-2H6a3 3 0 0 1-3-3v-1a7 7 0 0 1 7-7h1V5.72A2 2 0 0 1 10 4a2 2 0 0 1 2-2z"/></svg>
        </div>
        <span class="action-btn-label">Ask Sahayak</span>
      </button>

      <button class="action-card-btn" id="btnQuickDocCenter">
        <div class="action-icon-circle">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
        </div>
        <span class="action-btn-label">e-Gazettes</span>
      </button>

      <button class="action-card-btn" id="btnQuickIDCard">
        <div class="action-icon-circle">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2z"/></svg>
        </div>
        <span class="action-btn-label">Digital ID</span>
      </button>
    </div>

    <!-- 4. Real-Time Transit Alert Banner -->
    <div class="card transit-preview-card tilt-card" id="transitAlertCard">
      <div class="transit-icon-box">
        <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 2c-4.42 0-8 .5-8 4v10c0 .88.39 1.67 1 2.22V20c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h8v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1.78c.61-.55 1-1.34 1-2.22V6c0-3.5-3.58-4-8-4z"/></svg>
      </div>
      <div class="transit-info-col">
        <div class="transit-title-row">
          <span class="transit-route-name">Route 1: Dindigul ↔ GRI</span>
          <span class="transit-eta-badge">ETA 8 mins</span>
        </div>
        <p class="transit-subtext">Bus TN-57-N-2418 • Approaching Chinnalapatti Four-Roads Stop</p>
      </div>
    </div>

    <!-- 5. Urgent University Circulars -->
    <div class="section-header-row">
      <span class="section-title">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M20 2H4c-1.1 0-1.99.9-1.99 2L2 22l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-7 9h-2V5h2v6zm0 4h-2v-2h2v2z"/></svg>
        Statutory Circulars & Gazettes
      </span>
      <a href="#" class="section-action-link" id="viewAllCircularsLink">View all</a>
    </div>

    <div class="circulars-list">
      ${state.circulars.map(c => `
        <div class="notice-item-card" data-id="${c.id}">
          <span class="notice-pill-tag ${c.urgent ? 'urgent' : ''}">${c.urgent ? 'URGENT' : c.category}</span>
          <div class="notice-content-col">
            <h4 class="notice-title">${c.title}</h4>
            <p class="notice-summary">${c.summary}</p>
            <div class="notice-meta-line">Issued by ${c.issuedBy} • ${c.date}</div>
          </div>
        </div>
      `).join('')}
    </div>
  `;

  // Attach button triggers
  document.getElementById('btnQuickHallTicket')?.addEventListener('click', openHallTicketModal);
  document.getElementById('btnQuickGrievance')?.addEventListener('click', () => switchTab('services'));
  document.getElementById('btnQuickBus')?.addEventListener('click', () => switchTab('campus'));
  document.getElementById('btnQuickSahayak')?.addEventListener('click', openSahayakModal);
  document.getElementById('btnQuickDocCenter')?.addEventListener('click', openDocCenterModal);
  document.getElementById('btnQuickIDCard')?.addEventListener('click', () => switchTab('services'));
  document.getElementById('transitAlertCard')?.addEventListener('click', () => switchTab('campus'));
  document.getElementById('viewAllCircularsLink')?.addEventListener('click', (e) => {
    e.preventDefault();
    openDocCenterModal();
  });

  attach3DTiltHandlers();
}

// Screen 2: Academics Hub
function renderAcademicsScreen() {
  el.screenAcademics.innerHTML = `
    <!-- Subtabs -->
    <div class="subtab-pill-bar">
      <button class="subtab-pill active" data-sub="courses">Registered Courses</button>
      <button class="subtab-pill" data-sub="exams">Exam Timetable</button>
      <button class="subtab-pill" data-sub="hallticket">Hall Ticket</button>
      <button class="subtab-pill" data-sub="calculator">Attendance Calc</button>
    </div>

    <!-- Courses View -->
    <div class="courses-container" id="coursesSubtabView">
      <div class="section-header-row">
        <span class="section-title">CBCS Curriculum • Even Semester 2026</span>
        <span style="font-size: 11px; font-weight: 700; color: var(--color-primary);">17 Total Credits</span>
      </div>

      ${state.courses.map(course => {
        const isSafe = course.attendance >= 80;
        const isWarning = course.attendance >= 75 && course.attendance < 80;
        const fillClass = isSafe ? 'safe' : (isWarning ? 'warning' : 'danger');

        return `
          <div class="card course-item-card tilt-card">
            <div class="course-header-row">
              <div>
                <span class="course-code-badge">${course.code} • ${course.credits} Credits</span>
                <h3 class="course-title">${course.title}</h3>
                <span class="course-instructor">${course.instructor} • ${course.schedule}</span>
              </div>
              <button class="btn btn-sm btn-outline btn-mark-att" data-code="${course.code}">Check-in</button>
            </div>
            <div class="course-attendance-bar">
              <div class="bar-labels-row">
                <span>Biometric Attendance: ${course.attended}/${course.total} Hours</span>
                <span style="color: var(--color-${isSafe ? 'success' : (isWarning ? 'warning' : 'error')}); font-weight: 700;">${course.attendance}%</span>
              </div>
              <div class="progress-track">
                <div class="progress-fill ${fillClass}" style="width: ${course.attendance}%;"></div>
              </div>
            </div>
          </div>
        `;
      }).join('')}

      <div class="card" style="margin-top: var(--space-md); text-align: center; padding: var(--space-lg);">
        <h4 style="font-family: var(--font-display); font-size: 14px; margin-bottom: 6px;">End Semester Examinations (ESE) Nov/Dec 2026</h4>
        <p style="font-size: 11px; color: var(--color-text-secondary); margin-bottom: var(--space-md);">Cryptographic QR Hall Tickets are authenticated by e-SANAD.</p>
        <button class="btn btn-primary" id="btnOpenHallTicketFromAcad">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M22 10V6c0-1.11-.9-2-2-2H4c-1.1 0-1.99.89-1.99 2v4c1.1 0 1.99.9 1.99 2s-.89 2-2 2v4c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2v-4c-1.1 0-2-.9-2-2s.9-2 2-2z"/></svg>
          View e-SANAD Hall Ticket
        </button>
      </div>
    </div>
  `;

  document.getElementById('btnOpenHallTicketFromAcad')?.addEventListener('click', openHallTicketModal);

  document.querySelectorAll('.btn-mark-att').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const code = e.currentTarget.getAttribute('data-code');
      showToast(`Biometric check-in recorded for course ${code}. Attendance verified!`);
    });
  });

  attach3DTiltHandlers();
}

// Screen 3: Campus & Facilities Hub
function renderCampusScreen() {
  el.screenCampus.innerHTML = `
    <!-- Live Transit GPS Tracker Simulator -->
    <div class="section-header-row">
      <span class="section-title">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M12 2c-4.42 0-8 .5-8 4v10c0 .88.39 1.67 1 2.22V20c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h8v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1.78c.61-.55 1-1.34 1-2.22V6c0-3.5-3.58-4-8-4z"/></svg>
        Live Transit GPS Radar
      </span>
      <span style="font-size: 11px; font-weight: 700; color: var(--color-success);">LIVE SATELLITE FEED</span>
    </div>

    <div class="transit-map-simulation" id="transitMapSim">
      <div class="map-grid-overlay"></div>
      <div class="map-route-line"></div>
      <div class="map-station-stop stop-start" title="Origin Terminus"></div>
      <div class="map-station-stop stop-mid" title="Chinnalapatti Gate"></div>
      <div class="map-station-stop stop-end" title="GRI Main Gate"></div>
      <div class="map-bus-pin" id="busRadarPin" style="left: 68%;">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M4 16c0 .88.39 1.67 1 2.22V20c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h8v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1.78c.61-.55 1-1.34 1-2.22V6c0-3.5-3.58-4-8-4s-8 .5-8 4v10z"/></svg>
      </div>
      <div class="map-hud-overlay">
        <span>Bus TN-57-N-2418 (Route 1)</span>
        <span style="color: #34D399;">Speed: 42 km/h • ETA: 8 min</span>
      </div>
    </div>

    <!-- Bus Routes List -->
    ${state.busRoutes.map(route => `
      <div class="card bus-route-card tilt-card" data-bus="${route.id}">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
          <div>
            <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700;">${route.name}</h4>
            <div style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">
              Bus ${route.busNo} • Driver: ${route.driver}
            </div>
            <div style="font-size: 11px; color: var(--color-primary); font-weight: 600; margin-top: 4px;">
              ${route.status}
            </div>
          </div>
          <span style="font-family: var(--font-mono); font-size: 12px; font-weight: 700; color: var(--color-success);">${route.eta}</span>
        </div>
        <div class="bus-action-row">
          <a href="tel:${route.phone}" class="btn btn-sm btn-outline">
            <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg>
            Call Driver
          </a>
          <button class="btn btn-sm btn-primary btn-track-bus" data-id="${route.id}">Track GPS</button>
        </div>
      </div>
    `).join('')}

    <!-- Campus Landmarks -->
    <div class="section-header-row" style="margin-top: var(--space-lg);">
      <span class="section-title">Key Campus Facilities</span>
    </div>

    <div class="card tilt-card">
      <h4 style="font-family: var(--font-display); font-size: 14px; font-weight: 700;">Dr. G. Ramachandran Central Library</h4>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">Over 1,75,000 volumes, rare Gandhian archives, RFID self-checkout kiosks.</p>
      <div style="display: flex; gap: 8px; margin-top: 8px;">
        <span class="role-pill-chip" style="background: var(--color-surface-elevated); padding: 4px 8px; border-radius: 4px;">Open 08:00 AM - 08:00 PM</span>
        <span class="role-pill-chip" style="background: var(--color-success-bg); color: var(--color-success); padding: 4px 8px; border-radius: 4px;">RFID: Online</span>
      </div>
    </div>

    <div class="card tilt-card">
      <h4 style="font-family: var(--font-display); font-size: 14px; font-weight: 700;">University Hostels & Dining</h4>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">Thamarai Illam (Men) • Malligai Illam (Women) • Kasturba Scholars Hostel.</p>
      <div style="font-size: 11px; color: var(--color-tertiary); font-weight: 600; margin-top: 6px;">Today's Lunch: Traditional South Indian Meal & Sambar (12:30 PM - 02:00 PM)</div>
    </div>
  `;

  document.querySelectorAll('.btn-track-bus').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const id = e.currentTarget.getAttribute('data-id');
      const pin = document.getElementById('busRadarPin');
      if (pin) {
        pin.style.left = (Math.random() * 60 + 20).toFixed(0) + '%';
      }
      showToast(`Tracking live telemetry for ${id.toUpperCase()}`);
    });
  });

  attach3DTiltHandlers();
}

// Screen 4: Student Services & GRI-Care
function renderServicesScreen() {
  const u = state.users[state.currentRole] || state.users.STUDENT;

  el.screenServices.innerHTML = `
    <!-- 1. Interactive 3D Flip Student ID Card -->
    <div class="section-header-row">
      <span class="section-title">Digital Identity Credentials</span>
      <span class="id-flip-hint">
        <svg viewBox="0 0 24 24" width="12" height="12" fill="currentColor"><path d="M12 4V1L8 5l4 4V6c3.31 0 6 2.69 6 6 0 1.01-.25 1.97-.7 2.8l1.46 1.46C19.54 15.03 20 13.57 20 12c0-4.42-3.58-8-8-8zm0 14c-3.31 0-6-2.69-6-6 0-1.01.25-1.97.7-2.8L5.24 7.74C4.46 8.97 4 10.43 4 12c0 4.42 3.58 8 8 8v3l4-4-4-4v3z"/></svg>
        Tap to 3D Flip
      </span>
    </div>

    <div class="id-card-perspective-container" id="idCardFlipperContainer">
      <div class="id-card-3d-flipper">
        <!-- Front Face -->
        <div class="id-card-face id-card-front">
          <div class="id-card-top-row">
            <div style="display: flex; align-items: center; gap: 8px;">
              <img src="/assets/gri_official_logo.png" alt="GRI Logo" style="width: 28px; height: 28px; object-fit: contain; background: #fff; border-radius: 4px; padding: 2px;">
              <div>
                <div class="id-univ-header">THE GANDHIGRAM RURAL INSTITUTE</div>
                <div style="font-size: 9px; opacity: 0.85;">(Deemed to be University) • NAAC 'A+' Grade</div>
              </div>
            </div>
            <div class="id-chip-icon"></div>
          </div>

          <div class="id-center-info">
            <img src="/assets/student_avatar.jpg" alt="${u.name}" class="id-student-photo">
            <div>
              <div class="id-student-name">${u.name}</div>
              <div class="id-student-roll">${u.rollNo}</div>
              <div style="font-size: 10px; opacity: 0.9; margin-top: 2px;">${u.program}</div>
            </div>
          </div>

          <div class="id-footer-row">
            <span>Valid Thru: ${u.validThru}</span>
            <span style="font-family: var(--font-mono); font-weight: 700;">RFID • NFC ENABLED</span>
          </div>
        </div>

        <!-- Back Face -->
        <div class="id-card-face id-card-back">
          <div class="id-card-top-row">
            <span style="font-family: var(--font-display); font-size: 11px; font-weight: 700; color: #99D3B2;">EMERGENCY & LIBRARY BARCODE</span>
            <span style="font-size: 10px;">Blood: O+ve</span>
          </div>

          <div style="font-size: 11px; line-height: 1.4; color: #A3B8AD;">
            <div>Hostel: ${u.hostelName}</div>
            <div>Transit: ${u.busPass}</div>
            <div>Emergency Contact: GRI Health Centre (+91 451 2452371)</div>
          </div>

          <!-- Barcode Mock -->
          <div style="background: #fff; padding: 6px; border-radius: 4px; display: flex; flex-direction: column; align-items: center;">
            <div style="width: 100%; height: 26px; background: repeating-linear-gradient(90deg, #000 0, #000 2px, #fff 2px, #fff 5px);"></div>
            <span style="font-family: var(--font-mono); font-size: 9px; color: #000; margin-top: 2px;">*GRI-23MCA042-ID*</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 2. Zero Ragging & GRI-Care Form -->
    <div class="section-header-row" style="margin-top: var(--space-md);">
      <span class="section-title">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/></svg>
        GRI-Care Grievance Redressal
      </span>
      <span class="role-pill-chip" style="background: var(--color-error-bg); color: var(--color-error);">Zero Ragging</span>
    </div>

    <div class="card tilt-card">
      <form id="grievanceForm">
        <div class="form-group">
          <label class="form-label">Category</label>
          <select class="form-select" id="grievanceCategory">
            <option value="Academics & Evaluation">Academics & Evaluation</option>
            <option value="Hostel & Dining">Hostel & Dining</option>
            <option value="Transport & Bus Services">Transport & Bus Services</option>
            <option value="Infrastructure & Wi-Fi">Infrastructure & Wi-Fi</option>
            <option value="Scholarships & Fees">Scholarships & Fees</option>
            <option value="Anti-Ragging / Confidential">Anti-Ragging / Confidential</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">Subject / Issue Summary</label>
          <input type="text" class="form-input" id="grievanceSubject" placeholder="Brief subject of the grievance" required>
        </div>

        <div class="form-group">
          <label class="form-label">Detailed Description</label>
          <textarea class="form-textarea" id="grievanceDesc" placeholder="Provide full details, locations, and dates..." required></textarea>
        </div>

        <button type="submit" class="btn btn-primary btn-full">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
          Register Statutory Grievance
        </button>
      </form>
    </div>

    <!-- Active Tickets List -->
    <div class="section-header-row">
      <span class="section-title">My Registered Grievance Tickets</span>
    </div>

    <div id="grievanceListContainer">
      ${state.grievances.map(g => `
        <div class="card tilt-card" style="border-left: 4px solid var(--color-${g.status === 'RESOLVED' ? 'success' : 'warning'});">
          <div style="display: flex; justify-content: space-between; align-items: flex-start;">
            <div>
              <span class="course-code-badge">${g.id} • ${g.category}</span>
              <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; margin-top: 4px;">${g.subject}</h4>
            </div>
            <span class="role-pill-chip" style="background: var(--color-${g.status === 'RESOLVED' ? 'success-bg' : 'warning-bg'}); color: var(--color-${g.status === 'RESOLVED' ? 'success' : 'warning'});">${g.status}</span>
          </div>
          <div style="font-size: 11px; color: var(--color-text-secondary); margin-top: 6px;">
            ${g.remarks}
          </div>
          <div style="font-size: 10px; color: var(--color-text-muted); margin-top: 4px;">Registered on ${g.date}</div>
        </div>
      `).join('')}
    </div>
  `;

  // 3D Flip Card Handler
  const flipContainer = document.getElementById('idCardFlipperContainer');
  if (flipContainer) {
    flipContainer.addEventListener('click', () => {
      flipContainer.classList.toggle('flipped');
      HapticFeedback.click();
    });
  }

  // Grievance submission handler
  const form = document.getElementById('grievanceForm');
  if (form) {
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      const cat = document.getElementById('grievanceCategory').value;
      const sub = document.getElementById('grievanceSubject').value;
      const desc = document.getElementById('grievanceDesc').value;

      const newTicket = {
        id: `GRI-2026-TKT-${Math.floor(1000 + Math.random() * 9000)}`,
        category: cat,
        subject: sub,
        date: 'Just now',
        status: 'SUBMITTED',
        progress: 25,
        remarks: 'Acknowledged by Central Care Cell. Assigned to competent officer.'
      };

      state.grievances.unshift(newTicket);
      HapticFeedback.success();
      showToast(`Grievance filed successfully! Ticket #${newTicket.id}`);
      form.reset();
      renderServicesScreen();
    });
  }

  attach3DTiltHandlers();
}

// Screen 5: Admin & Governance Hub
function renderAdminScreen() {
  el.screenAdmin.innerHTML = `
    <!-- Multi-Role Switching Control -->
    <div class="card tilt-card">
      <h3 style="font-family: var(--font-display); font-size: 15px; font-weight: 700; margin-bottom: 6px;">Multi-Role Institutional Simulation</h3>
      <p style="font-size: 12px; color: var(--color-text-secondary); margin-bottom: var(--space-sm);">Switch role to dynamically transform navigation, permissions, and available administrative faculties.</p>
      
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-xs);">
        <button class="btn btn-sm ${state.currentRole === 'STUDENT' ? 'btn-primary' : 'btn-outline'} btn-role-pick" data-role="STUDENT">Student</button>
        <button class="btn btn-sm ${state.currentRole === 'FACULTY' ? 'btn-primary' : 'btn-outline'} btn-role-pick" data-role="FACULTY">Faculty</button>
        <button class="btn btn-sm ${state.currentRole === 'ADMIN' ? 'btn-primary' : 'btn-outline'} btn-role-pick" data-role="ADMIN">Admin / CoE</button>
        <button class="btn btn-sm ${state.currentRole === 'STAFF' ? 'btn-primary' : 'btn-outline'} btn-role-pick" data-role="STAFF">Staff</button>
        <button class="btn btn-sm ${state.currentRole === 'SCHOLAR' ? 'btn-primary' : 'btn-outline'} btn-role-pick" data-role="SCHOLAR">Scholar</button>
        <button class="btn btn-sm ${state.currentRole === 'GUEST' ? 'btn-primary' : 'btn-outline'} btn-role-pick" data-role="GUEST">Guest / Public</button>
      </div>
    </div>

    <!-- Official Notice Publishing Studio (For Admin) -->
    <div class="card tilt-card">
      <div class="section-header-row" style="margin-top: 0;">
        <span class="section-title">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
          Publish Statutory Circular
        </span>
        <span class="role-pill-chip" style="background: var(--color-primary-container); color: var(--color-primary);">CoE Authorized</span>
      </div>

      <form id="publishNoticeForm">
        <div class="form-group">
          <label class="form-label">Notice Title</label>
          <input type="text" class="form-input" id="pubTitle" placeholder="e.g. Schedule of Ph.D. Public Viva-Voce Examination" required>
        </div>

        <div class="form-group">
          <label class="form-label">Category</label>
          <select class="form-select" id="pubCategory">
            <option value="Examinations">Examinations & Hall Tickets</option>
            <option value="Academics">Academic Regulations & CBCS</option>
            <option value="Administration">Registrar Secretariat Orders</option>
            <option value="Admissions">Admissions & CUET Notices</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">Summary / Executive Brief</label>
          <textarea class="form-textarea" id="pubSummary" placeholder="Summary text for instant notification broadcast..." required></textarea>
        </div>

        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: var(--space-sm);">
          <input type="checkbox" id="pubUrgent" style="width: 16px; height: 16px; accent-color: var(--color-error);">
          <label for="pubUrgent" style="font-size: 12px; font-weight: 600;">Flag as High-Priority Urgent Gazetted Circular</label>
        </div>

        <button type="submit" class="btn btn-primary btn-full">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
          Publish Notice to Institutional Ledger
        </button>
      </form>
    </div>

    <!-- Server & Offline Synchronization Engine -->
    <div class="card tilt-card">
      <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
          <h4 style="font-family: var(--font-display); font-size: 14px; font-weight: 700;">Embedded Ktor & Cloud Sync</h4>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">Local Port: 8080 • State: Live & Synced</p>
        </div>
        <button class="btn btn-sm btn-outline" id="btnSyncFromAdmin">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M12 4V1L8 5l4 4V6c3.31 0 6 2.69 6 6 0 1.01-.25 1.97-.7 2.8l1.46 1.46C19.54 15.03 20 13.57 20 12c0-4.42-3.58-8-8-8z"/></svg>
          Sync Cloud
        </button>
      </div>
    </div>
  `;

  document.querySelectorAll('.btn-role-pick').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const r = e.currentTarget.getAttribute('data-role');
      switchRole(r);
    });
  });

  document.getElementById('btnSyncFromAdmin')?.addEventListener('click', triggerSync);

  const pubForm = document.getElementById('publishNoticeForm');
  if (pubForm) {
    pubForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const title = document.getElementById('pubTitle').value;
      const cat = document.getElementById('pubCategory').value;
      const sum = document.getElementById('pubSummary').value;
      const urg = document.getElementById('pubUrgent').checked;

      const newNotice = {
        id: `CIR-2026-PUB-${Math.floor(100 + Math.random() * 900)}`,
        title,
        category: cat,
        date: 'Just now',
        issuedBy: 'Controller of Examinations',
        urgent: urg,
        summary: sum
      };

      state.circulars.unshift(newNotice);
      HapticFeedback.success();
      showToast(`Circular "${title}" published and broadcasted to campus!`);
      pubForm.reset();
      renderHomeScreen();
      renderAdminScreen();
    });
  }

  attach3DTiltHandlers();
}

// --- 8. Navigation & Tab Switching ---
function switchTab(tabId) {
  HapticFeedback.click();
  state.currentTab = tabId;

  // Update Bottom Nav active state
  document.querySelectorAll('.nav-item').forEach(btn => {
    btn.classList.toggle('active', btn.getAttribute('data-tab') === tabId);
  });

  // Update Screen Views
  document.querySelectorAll('.screen-view').forEach(view => {
    view.classList.toggle('active', view.getAttribute('data-screen') === tabId);
  });

  // Render content
  if (tabId === 'home') renderHomeScreen();
  if (tabId === 'academics') renderAcademicsScreen();
  if (tabId === 'campus') renderCampusScreen();
  if (tabId === 'services') renderServicesScreen();
  if (tabId === 'admin') renderAdminScreen();
}

// --- 9. Role Management ---
function switchRole(roleKey) {
  HapticFeedback.success();
  state.currentRole = roleKey;
  el.currentRoleChip.textContent = roleKey;
  el.globalRoleSelect.value = roleKey;

  showToast(`Switched active profile to ${state.users[roleKey].name} (${roleKey})`);

  // Re-render active screen
  switchTab(state.currentTab);
}

// --- 10. Modals Management ---

// Modal 1: GRI-Sahayak AI
function openSahayakModal() {
  HapticFeedback.click();
  el.sahayakModal.classList.add('active');
  renderSahayakChat();
  el.sahayakInput.focus();
}

function closeSahayakModal() {
  el.sahayakModal.classList.remove('active');
}

function renderSahayakChat() {
  el.sahayakChatBody.innerHTML = state.sahayakMessages.map(msg => `
    <div class="chat-bubble ${msg.isBot ? 'bot' : 'user'}">
      <div>${msg.text}</div>
      ${msg.source ? `<span class="chat-source-tag">${msg.source}</span>` : ''}
    </div>
  `).join('');
  el.sahayakChatBody.scrollTop = el.sahayakChatBody.scrollHeight;
}

function answerInstitutionalQuery(query) {
  const q = query.toLowerCase();
  if (q.includes('admission') || q.includes('cuet') || q.includes('apply')) {
    return "Admissions for the 2026-2027 academic year are open! GRI admits students for UG programmes through CUET-UG and PG programmes through CUET-PG conducted by NTA. Diploma and certificate courses admit candidates via university merit ranking through the Samarth portal (ruraluniv.ac.in/admissions).";
  } else if (q.includes('attendance') || q.includes('75') || q.includes('condonation')) {
    return "Under GRI CBCS Academic Regulations, every candidate must secure a minimum of 75% attendance in each course to be eligible to appear for the End Semester Examinations (ESE). Condonation (65% to 74%) may be granted by the Vice-Chancellor on valid medical grounds. Students with less than 65% attendance must repeat the course.";
  } else if (q.includes('exam') || q.includes('hall ticket') || q.includes('timetable') || q.includes('ese')) {
    return "End Semester Examination (ESE) Hall Tickets for Nov/Dec 2026 are generated online with e-SANAD QR tokens. You can view and print your Hall Ticket from the Home screen or Academics tab.";
  } else if (q.includes('bus') || q.includes('transport') || q.includes('route') || q.includes('timing')) {
    return "University bus services operate across 3 primary routes: Route 1 (Dindigul Junction ↔ GRI, 7:45 AM / 5:15 PM), Route 2 (Madurai Periyar ↔ Chinnalapatti ↔ GRI, 7:15 AM / 5:30 PM), and Route 3 (Batlagundu Bus Terminus ↔ GRI, 8:10 AM / 4:45 PM). Student bus passes are verified digitally.";
  } else if (q.includes('hostel') || q.includes('mess') || q.includes('warden')) {
    return "GRI provides residential complexes with modern dining: Thamarai Illam (Men), Malligai Illam (Women), and Kasturba Research Scholars Hostel. Mess timings: Breakfast 7:30–8:30 AM, Lunch 12:30–2:00 PM, Dinner 7:30–8:45 PM.";
  } else if (q.includes('tamil') || q.includes('தமிழ்') || q.includes('கிராமம்') || q.includes('வரலாறு')) {
    return "காந்திகிராம கிராமிய நிகர்நிலைப் பல்கலைக்கழகம் 1956-ஆம் ஆண்டு மகாத்மா காந்தியின் அடிப்படைக் கல்வி (நை தாலீம்) கொள்கையின்படி டாக்டர் டி.எஸ். சௌந்தரம் மற்றும் டாக்டர் ஜி. ராமச்சந்திரன் ஆகியோரால் நிறுவப்பட்டது. 'கிராமம் உயர நாடு உயரும்' என்பதே நமது தாரக மந்திரம்.";
  } else {
    return "Official institutional record verified: For detailed inquiries, please contact the Registrar's Office at registrar@ruraluniv.ac.in or University Helpline (+91 451 2452371).";
  }
}

function handleSahayakSubmit(promptText) {
  if (!promptText.trim()) return;

  state.sahayakMessages.push({ isBot: false, text: promptText });
  renderSahayakChat();
  el.sahayakInput.value = '';

  setTimeout(() => {
    const responseText = answerInstitutionalQuery(promptText);
    state.sahayakMessages.push({
      isBot: true,
      text: responseText,
      source: 'ruraluniv.ac.in • Statutory UGC e-Office Ledger'
    });
    HapticFeedback.click();
    renderSahayakChat();
  }, 400);
}

// Modal 2: Examination Hall Ticket
function openHallTicketModal() {
  HapticFeedback.click();
  const u = state.users[state.currentRole] || state.users.STUDENT;
  const ht = state.hallTicket;

  el.hallTicketView.innerHTML = `
    <div class="hall-ticket-paper" id="printableTicket">
      <div class="ht-header" style="display: flex; flex-direction: column; align-items: center; text-align: center;">
        <img src="/assets/gri_official_logo.png" alt="GRI Official Logo" style="width: 50px; height: 50px; object-fit: contain; margin-bottom: 6px;">
        <h2 class="ht-univ-title">THE GANDHIGRAM RURAL INSTITUTE</h2>
        <div class="ht-sub-title">(Deemed to be University) • Gandhigram, Dindigul District, Tamil Nadu</div>
        <div style="font-weight: 800; font-size: 13px; margin-top: 4px; color: #003622;">END SEMESTER EXAMINATIONS • NOV / DEC 2026</div>
        <div style="font-size: 11px; color: #64748B;">OFFICIAL EXAMINATION HALL TICKET • REGISTRAR COPY</div>
      </div>

      <div style="display: flex; gap: 12px; align-items: center; margin-bottom: 12px; background: #F8FAFD; padding: 10px; border-radius: 8px;">
        <img src="/assets/student_avatar.jpg" alt="${u.name}" style="width: 64px; height: 64px; border-radius: 6px; object-fit: cover; border: 1.5px solid #CBD5E1; flex-shrink: 0;">
        <div class="ht-student-grid" style="flex: 1; margin-bottom: 0; background: transparent; padding: 0;">
          <div><strong>Student Name:</strong> ${u.name}</div>
          <div><strong>Register / Roll No:</strong> ${u.rollNo}</div>
          <div><strong>Degree / Programme:</strong> ${u.program}</div>
          <div><strong>Semester:</strong> ${u.semester}</div>
          <div><strong>Department:</strong> ${u.department}</div>
          <div><strong>Hall Ticket No:</strong> ${ht.ticketNo}</div>
        </div>
      </div>

      <div style="font-size: 11px; margin-bottom: 8px;"><strong>Examination Center:</strong> ${ht.center}</div>

      <table class="ht-table">
        <thead>
          <tr>
            <th>Course Code</th>
            <th>Course Title</th>
            <th>Exam Date</th>
            <th>Session</th>
            <th>Hall & Desk</th>
          </tr>
        </thead>
        <tbody>
          ${ht.exams.map(e => `
            <tr>
              <td><strong>${e.code}</strong></td>
              <td>${e.title}</td>
              <td>${e.date}</td>
              <td>${e.session}</td>
              <td>${e.hall} (${e.desk})</td>
            </tr>
          `).join('')}
        </tbody>
      </table>

      <div class="ht-qr-security">
        <div>
          <div style="font-size: 10px; font-weight: 700; color: #003622;">CRYPTOGRAPHIC SEAL AUTHENTICATED</div>
          <div style="font-family: var(--font-mono); font-size: 9px; color: #475569;">${ht.sanadCode}</div>
          <div style="font-size: 9px; color: #64748B; margin-top: 2px;">Verified by UGC National Academic Depository & e-SANAD</div>
        </div>
        <div class="crypto-qr-mock">
          ${Array.from({length: 16}).map(() => '<div class="qr-dot"></div>').join('')}
        </div>
      </div>
    </div>
  `;

  el.hallTicketModal.classList.add('active');
}

function closeHallTicketModal() {
  el.hallTicketModal.classList.remove('active');
}

// Modal 3: Document Center
function openDocCenterModal() {
  HapticFeedback.click();
  renderDocList();
  el.docCenterModal.classList.add('active');
}

function closeDocCenterModal() {
  el.docCenterModal.classList.remove('active');
}

function renderDocList(category = 'all') {
  const docs = [
    { id: 'DOC-2026-01', title: 'GRI Admission Prospectus 2026-2027', cat: 'admissions', size: '4.2 MB', date: 'Aug 2026' },
    { id: 'DOC-2026-02', title: 'End Semester Exam Schedule Nov-Dec 2026', cat: 'examinations', size: '1.8 MB', date: 'Sep 2026' },
    { id: 'DOC-2026-03', title: 'CBCS Curriculum Regulations & Syllabi 2026', cat: 'academics', size: '8.5 MB', date: 'Jul 2026' },
    { id: 'DOC-2026-04', title: 'Post-Matric & Merit Scholarship Guidelines', cat: 'finance', size: '2.1 MB', date: 'Sep 2026' },
    { id: 'DOC-2026-05', title: 'Nai Talim Village Internship Manual', cat: 'academics', size: '3.6 MB', date: 'Aug 2026' }
  ];

  const filtered = category === 'all' ? docs : docs.filter(d => d.cat === category);

  el.docListContainer.innerHTML = filtered.map(d => `
    <div class="card" style="margin-bottom: var(--space-xs); padding: var(--space-sm); display: flex; justify-content: space-between; align-items: center;">
      <div>
        <span class="course-code-badge">${d.id} • ${d.cat.toUpperCase()}</span>
        <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; margin-top: 4px;">${d.title}</h4>
        <div style="font-size: 10px; color: var(--color-text-muted); margin-top: 2px;">${d.size} • Published ${d.date}</div>
      </div>
      <button class="btn btn-sm btn-outline btn-download-doc" data-id="${d.id}">
        <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M19.35 10.04C18.67 6.59 15.64 4 12 4 9.11 4 6.6 5.64 5.35 8.04 2.34 8.36 0 10.91 0 14c0 3.31 2.69 6 6 6h13c2.76 0 5-2.24 5-5 0-2.64-2.05-4.78-4.65-4.96zM17 13l-5 5-5-5h3V9h4v4h3z"/></svg>
        Download
      </button>
    </div>
  `).join('');

  document.querySelectorAll('.btn-download-doc').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const id = e.currentTarget.getAttribute('data-id');
      showToast(`Downloaded verified document ${id}`);
    });
  });
}

// Modal 4: Notifications Drawer
function openNotifModal() {
  HapticFeedback.click();
  renderNotifList();
  el.notifModal.classList.add('active');
}

function closeNotifModal() {
  el.notifModal.classList.remove('active');
}

function renderNotifList() {
  const notifs = [
    { title: 'End Semester Hall Ticket Released', text: 'Nov/Dec 2026 Examination hall tickets are live on e-SANAD.', time: '10m ago', unread: true },
    { title: 'Campus Transit Route 1 Update', text: 'Bus TN-57-N-2418 is running on schedule via Chinnalapatti.', time: '25m ago', unread: true },
    { title: 'Library Book Due Reminder', text: 'Distributed Mobile Systems book due on 28 Sep 2026.', time: '2h ago', unread: true },
    { title: 'GRI-Care Ticket Updated', text: 'Ticket #GRI-2026-TKT-8912 marked as RESOLVED by Estate Office.', time: '1d ago', unread: false }
  ];

  el.notifList.innerHTML = notifs.map(n => `
    <div class="card" style="margin-bottom: var(--space-xs); padding: var(--space-sm); background: ${n.unread ? 'var(--color-surface-elevated)' : 'var(--color-surface)'}; border-left: 3px solid ${n.unread ? 'var(--color-primary)' : 'transparent'};">
      <div style="display: flex; justify-content: space-between; align-items: center;">
        <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700;">${n.title}</h4>
        <span style="font-size: 10px; color: var(--color-text-muted);">${n.time}</span>
      </div>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 3px;">${n.text}</p>
    </div>
  `).join('');
}

// Cloud Sync Trigger
function triggerSync() {
  if (state.isSyncing) return;
  state.isSyncing = true;
  HapticFeedback.click();
  showToast('Connecting to GRI Cloud & Ktor sync ledger...');

  setTimeout(() => {
    state.isSyncing = false;
    HapticFeedback.success();
    showToast('Synchronization complete! All records up to date.');
  }, 1200);
}

// --- 11. Event Listeners Initialization ---
function initEvents() {
  // Bezel toggle
  el.toggleDeviceFrameBtn?.addEventListener('click', () => {
    state.hasBezel = !state.hasBezel;
    el.mobileFrameContainer.classList.toggle('no-frame', !state.hasBezel);
    el.toggleDeviceFrameBtn.classList.toggle('active', state.hasBezel);
    showToast(state.hasBezel ? 'Smartphone bezel frame enabled' : 'Fullscreen responsive mode enabled');
  });

  // Global Theme toggle
  el.toggleGlobalThemeBtn?.addEventListener('click', () => {
    state.theme = state.theme === 'dark' ? 'light' : 'dark';
    document.body.className = `theme-${state.theme}`;
    el.themeBtnText.textContent = state.theme === 'dark' ? 'Dark' : 'Light';
    showToast(`Switched to ${state.theme.toUpperCase()} theme`);
  });

  // Quick sync button
  el.quickSyncBtn?.addEventListener('click', triggerSync);

  // Global role select dropdown
  el.globalRoleSelect?.addEventListener('change', (e) => {
    switchRole(e.target.value);
  });

  // Top bar role chip click -> open admin tab
  el.roleBadgeBtn?.addEventListener('click', () => {
    switchTab('admin');
  });

  // Bottom Nav items
  document.querySelectorAll('.nav-item').forEach(item => {
    item.addEventListener('click', () => {
      const tab = item.getAttribute('data-tab');
      switchTab(tab);
    });
  });

  // Sahayak Modal triggers
  el.openSahayakBtn?.addEventListener('click', openSahayakModal);
  el.closeSahayakBtn?.addEventListener('click', closeSahayakModal);
  el.sahayakForm?.addEventListener('submit', (e) => {
    e.preventDefault();
    handleSahayakSubmit(el.sahayakInput.value);
  });

  // Sahayak Prompt chips
  document.querySelectorAll('#sahayakChips .chip-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const q = btn.getAttribute('data-query');
      handleSahayakSubmit(q);
    });
  });

  // Hall Ticket Modal triggers
  el.closeHallTicketBtn?.addEventListener('click', closeHallTicketModal);
  el.doneTicketBtn?.addEventListener('click', closeHallTicketModal);
  el.printTicketBtn?.addEventListener('click', () => {
    window.print();
  });

  // Document Center triggers
  el.openDocCenterBtn?.addEventListener('click', openDocCenterModal);
  el.closeDocCenterBtn?.addEventListener('click', closeDocCenterModal);
  el.btnVerifyHash?.addEventListener('click', () => {
    const val = el.verifyHashInput.value.trim().toUpperCase();
    if (val.includes('GRI') || val.includes('COE') || val.includes('SANAD')) {
      el.verifyResultBanner.style.display = 'flex';
      el.verifyResultText.textContent = `Cryptographic SHA-256 Token "${val}" Authenticated by Central Registry & CoE`;
      showToast('SHA-256 Gazette Seal Authenticated!');
    } else {
      el.verifyResultBanner.style.display = 'flex';
      el.verifyResultText.textContent = `Token "${val}" not found in statutory e-Office ledger.`;
      showToast('Seal verification failed', 'error');
    }
  });

  // Notifications Modal triggers
  el.openNotificationsBtn?.addEventListener('click', openNotifModal);
  el.closeNotifBtn?.addEventListener('click', closeNotifModal);
  el.markAllReadBtn?.addEventListener('click', () => {
    el.notifBadge.style.display = 'none';
    el.unreadNotifCount.textContent = '0 New';
    showToast('All notifications marked as read');
    renderNotifList();
  });

  // Close modals on overlay backdrop click
  document.querySelectorAll('.modal-overlay').forEach(modal => {
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        modal.classList.remove('active');
      }
    });
  });

  // Dynamic Island click -> open transit screen or notification
  document.getElementById('dynamicIsland')?.addEventListener('click', () => {
    switchTab('campus');
    showToast('Navigating to Live Transit Radar');
  });

  // Initial render
  renderHomeScreen();
}

// Run on load
document.addEventListener('DOMContentLoaded', initEvents);
