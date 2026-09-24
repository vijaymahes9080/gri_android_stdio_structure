/**
 * ============================================================================
 * GRI MOBILE PORTAL 2026 — INSTITUTIONAL MULTI-ROLE & AUTHENTICATION ENGINE
 * The Gandhigram Rural Institute (Deemed to be University)
 * ============================================================================
 */

// --- 1. Institutional Permissions Definition ---
const PERMISSIONS = {
  // Public
  VIEW_PUBLIC: 'view_public',
  VIEW_ANNOUNCEMENTS: 'view_announcements',
  VIEW_CAMPUS_INFO: 'view_campus_info',
  // Student
  VIEW_STUDENT_DASHBOARD: 'view_student_dashboard',
  VIEW_ACADEMICS: 'view_academics',
  MARK_STUDENT_ATTENDANCE: 'mark_student_attendance',
  VIEW_HALL_TICKET: 'view_hall_ticket',
  FILE_GRIEVANCE: 'file_grievance',
  VIEW_DIGITAL_ID: 'view_digital_id',
  // Faculty
  VIEW_FACULTY_DASHBOARD: 'view_faculty_dashboard',
  MANAGE_COURSES: 'manage_courses',
  TAKE_LECTURE_ATTENDANCE: 'take_lecture_attendance',
  APPLY_STAFF_LEAVE: 'apply_staff_leave',
  // CoE Staff
  VIEW_COE_DASHBOARD: 'view_coe_dashboard',
  MANAGE_EXAM_SCHEDULES: 'manage_exam_schedules',
  ISSUE_HALL_TICKETS: 'issue_hall_tickets',
  VERIFY_SANAD_SEAL: 'verify_sanad_seal',
  // Scholar
  VIEW_SCHOLAR_DASHBOARD: 'view_scholar_dashboard',
  ACCESS_RESEARCH_LIBRARY: 'access_research_library',
  // Admin & Governance
  VIEW_ADMIN_DASHBOARD: 'view_admin_dashboard',
  MANAGE_REGISTRATIONS: 'manage_registrations',
  APPROVE_REJECT_APPLICATIONS: 'approve_reject_applications',
  ASSIGN_ROLES: 'assign_roles',
  PUBLISH_STATUTORY_CIRCULARS: 'publish_statutory_circulars',
  VIEW_AUDIT_LOGS: 'view_audit_logs',
  SYNC_CLOUD_LEDGER: 'sync_cloud_ledger',
  // Universal
  USE_SAHAYAK_AI: 'use_sahayak_ai',
  VIEW_TRANSIT_RADAR: 'view_transit_radar'
};

const ROLE_PERMISSIONS_MAP = {
  PUBLIC: [
    PERMISSIONS.VIEW_PUBLIC,
    PERMISSIONS.VIEW_ANNOUNCEMENTS,
    PERMISSIONS.VIEW_CAMPUS_INFO
  ],
  GUEST: [
    PERMISSIONS.VIEW_PUBLIC,
    PERMISSIONS.VIEW_ANNOUNCEMENTS,
    PERMISSIONS.VIEW_CAMPUS_INFO,
    PERMISSIONS.USE_SAHAYAK_AI,
    PERMISSIONS.VIEW_TRANSIT_RADAR
  ],
  STUDENT: [
    PERMISSIONS.VIEW_STUDENT_DASHBOARD,
    PERMISSIONS.VIEW_ACADEMICS,
    PERMISSIONS.MARK_STUDENT_ATTENDANCE,
    PERMISSIONS.VIEW_HALL_TICKET,
    PERMISSIONS.FILE_GRIEVANCE,
    PERMISSIONS.VIEW_DIGITAL_ID,
    PERMISSIONS.VIEW_TRANSIT_RADAR,
    PERMISSIONS.USE_SAHAYAK_AI,
    PERMISSIONS.VIEW_ANNOUNCEMENTS
  ],
  FACULTY: [
    PERMISSIONS.VIEW_FACULTY_DASHBOARD,
    PERMISSIONS.MANAGE_COURSES,
    PERMISSIONS.TAKE_LECTURE_ATTENDANCE,
    PERMISSIONS.APPLY_STAFF_LEAVE,
    PERMISSIONS.VIEW_ANNOUNCEMENTS,
    PERMISSIONS.USE_SAHAYAK_AI,
    PERMISSIONS.VIEW_TRANSIT_RADAR
  ],
  COE_STAFF: [
    PERMISSIONS.VIEW_COE_DASHBOARD,
    PERMISSIONS.MANAGE_EXAM_SCHEDULES,
    PERMISSIONS.ISSUE_HALL_TICKETS,
    PERMISSIONS.VERIFY_SANAD_SEAL,
    PERMISSIONS.PUBLISH_STATUTORY_CIRCULARS,
    PERMISSIONS.VIEW_ANNOUNCEMENTS,
    PERMISSIONS.USE_SAHAYAK_AI
  ],
  SCHOLAR: [
    PERMISSIONS.VIEW_SCHOLAR_DASHBOARD,
    PERMISSIONS.ACCESS_RESEARCH_LIBRARY,
    PERMISSIONS.VIEW_ACADEMICS,
    PERMISSIONS.USE_SAHAYAK_AI,
    PERMISSIONS.VIEW_ANNOUNCEMENTS,
    PERMISSIONS.VIEW_TRANSIT_RADAR
  ],
  ADMIN: [
    PERMISSIONS.VIEW_ADMIN_DASHBOARD,
    PERMISSIONS.MANAGE_REGISTRATIONS,
    PERMISSIONS.APPROVE_REJECT_APPLICATIONS,
    PERMISSIONS.ASSIGN_ROLES,
    PERMISSIONS.PUBLISH_STATUTORY_CIRCULARS,
    PERMISSIONS.VIEW_AUDIT_LOGS,
    PERMISSIONS.SYNC_CLOUD_LEDGER,
    PERMISSIONS.VIEW_ANNOUNCEMENTS,
    PERMISSIONS.USE_SAHAYAK_AI,
    PERMISSIONS.VIEW_TRANSIT_RADAR
  ]
};

// --- 2. Institutional Application State Store ---
const state = {
  theme: 'dark',
  hasBezel: true,
  currentTab: 'home',
  isSyncing: false,
  offlineQueueCount: 0,
  unreadNotifsCount: 3,

  // Authenticated Current User (Default: Admin to allow testing approval center out of the box)
  currentUser: null,

  // Registered Accounts in Institutional Ledger
  accounts: [
    {
      id: 'usr_admin',
      name: 'GRI Controller of Examinations',
      email: 'admin@ruraluniv.ac.in',
      mobile: '+91 451 2452371',
      institutionalId: 'ADMIN-GRI-01',
      status: 'APPROVED',
      approvedRoles: ['ADMIN'],
      activeRole: 'ADMIN',
      department: 'Central Administration & Samarth ERP Hub',
      program: 'Office of the Controller of Examinations',
      designation: 'Controller of Examinations & Authorized Statutory Officer',
      submittedAt: '10 Jan 2026, 09:00 AM',
      reviewedAt: '10 Jan 2026, 10:00 AM',
      reviewedBy: 'Vice-Chancellor Secretariat'
    },
    {
      id: 'usr_student',
      name: 'Srimari Vijay',
      email: 'student@ruraluniv.ac.in',
      mobile: '+91 94882 14209',
      institutionalId: '23MCA042',
      status: 'APPROVED',
      approvedRoles: ['STUDENT'],
      activeRole: 'STUDENT',
      department: 'Computer Science & Applications',
      program: 'Master of Computer Applications (MCA)',
      semester: 'Semester IV (Final Year)',
      cgpa: '8.92',
      attendance: 88.5,
      isHostelite: true,
      hostelName: 'Thamarai Illam (Room 214)',
      busPass: 'Route 1: Dindigul ↔ GRI',
      validThru: '2026-12-31',
      submittedAt: '15 Jul 2026, 10:30 AM',
      reviewedAt: '16 Jul 2026, 02:00 PM',
      reviewedBy: 'Dean of Student Welfare'
    },
    {
      id: 'usr_faculty',
      name: 'Dr. R. Subramanian',
      email: 'faculty@ruraluniv.ac.in',
      mobile: '+91 98421 95431',
      institutionalId: 'FAC-CS-108',
      status: 'APPROVED',
      approvedRoles: ['FACULTY', 'SCHOLAR'], // Legitimate Multi-Role User
      activeRole: 'FACULTY',
      department: 'School of Sciences & Rural Technology',
      program: 'Faculty of Computer Science',
      designation: 'Senior Associate Professor & Research Supervisor',
      cgpa: 'Ph.D. IIT Madras',
      attendance: 96.0,
      isHostelite: false,
      hostelName: 'Staff Quarters Type IV-B',
      busPass: 'University Shuttle',
      validThru: '2030-05-31',
      submittedAt: '01 Jun 2026, 11:00 AM',
      reviewedAt: '02 Jun 2026, 04:00 PM',
      reviewedBy: "Registrar's Office"
    },
    {
      id: 'usr_coe',
      name: 'M. Sadasivam',
      email: 'coe@ruraluniv.ac.in',
      mobile: '+91 94431 82415',
      institutionalId: 'COE-SEC-09',
      status: 'APPROVED',
      approvedRoles: ['COE_STAFF'],
      activeRole: 'COE_STAFF',
      department: 'Examination Confidential Branch',
      program: 'Examination Administration',
      designation: 'Deputy Registrar (Examinations)',
      attendance: 98.0,
      isHostelite: false,
      validThru: '2032-12-31',
      submittedAt: '12 Jan 2026, 09:30 AM',
      reviewedAt: '13 Jan 2026, 11:15 AM',
      reviewedBy: 'Controller of Examinations'
    },
    {
      id: 'usr_scholar',
      name: 'Ananya Murugan',
      email: 'scholar@ruraluniv.ac.in',
      mobile: '+91 97880 34120',
      institutionalId: '24PHD-ECO-09',
      status: 'APPROVED',
      approvedRoles: ['SCHOLAR'],
      activeRole: 'SCHOLAR',
      department: 'Rural Development & Sustainable Agro-Economy',
      program: 'Doctor of Philosophy (Ph.D.)',
      designation: 'Year 2 Research Scholar & UGC JRF Fellow',
      attendance: 92.4,
      isHostelite: true,
      hostelName: 'Kasturba Scholars Hostel',
      validThru: '2028-06-30',
      submittedAt: '20 Aug 2026, 03:00 PM',
      reviewedAt: '22 Aug 2026, 10:00 AM',
      reviewedBy: 'Dean of Academic Affairs'
    },
    {
      id: 'usr_pending',
      name: 'Kavitha Mohan',
      email: 'pending@ruraluniv.ac.in',
      mobile: '+91 98421 78420',
      institutionalId: '26MSC-CHE-12',
      status: 'PENDING',
      requestedRole: 'STUDENT',
      approvedRoles: [],
      activeRole: 'GUEST',
      applicationId: 'GRI-2026-APP-8104',
      department: 'Department of Chemistry',
      program: 'M.Sc. Applied Chemistry & Rural Industries',
      semester: 'Semester I',
      submittedAt: '24 Sep 2026, 11:30 AM',
      reviewedAt: null,
      reviewedBy: null,
      rejectionReason: null,
      infoRequested: null,
      infoProvided: null
    },
    {
      id: 'usr_review',
      name: 'Arun Kumar',
      email: 'review@ruraluniv.ac.in',
      mobile: '+91 94881 23091',
      institutionalId: '26BED-ENG-08',
      status: 'UNDER_REVIEW',
      requestedRole: 'STUDENT',
      approvedRoles: [],
      activeRole: 'GUEST',
      applicationId: 'GRI-2026-APP-7890',
      department: 'Department of Education',
      program: 'ITEP 4-Year B.Ed. Integrated Programme',
      semester: 'Semester I',
      submittedAt: '23 Sep 2026, 04:15 PM',
      reviewedAt: '24 Sep 2026, 09:30 AM',
      reviewedBy: 'Dean of Academic Affairs',
      rejectionReason: null,
      infoRequested: 'Please provide your UG Consolidated Marksheet Reference Number and official community quota verification document.',
      infoProvided: null
    }
  ],

  // Real-Time Audit Log Ledger
  auditTrail: [
    {
      id: 'aud_1',
      timestamp: '24 Sep 2026, 09:30 AM',
      actor: 'GRI Controller of Examinations (ADMIN)',
      targetUser: 'Arun Kumar (26BED-ENG-08)',
      action: 'INFO_REQUESTED',
      previousStatus: 'PENDING',
      newStatus: 'UNDER_REVIEW',
      remarks: 'Requested UG Consolidated Marksheet Reference & Community Certificate'
    },
    {
      id: 'aud_2',
      timestamp: '24 Sep 2026, 11:30 AM',
      actor: 'Kavitha Mohan (Applicant)',
      targetUser: 'Kavitha Mohan (26MSC-CHE-12)',
      action: 'REGISTRATION_SUBMITTED',
      previousStatus: 'NONE',
      newStatus: 'PENDING',
      remarks: 'Application logged to Central Registry. Ref: GRI-2026-APP-8104'
    },
    {
      id: 'aud_3',
      timestamp: '24 Sep 2026, 08:40 AM',
      actor: 'Dr. R. Subramanian (Faculty)',
      targetUser: 'Dr. R. Subramanian',
      action: 'ROLE_SWITCHED',
      previousStatus: 'FACULTY',
      newStatus: 'SCHOLAR',
      remarks: 'User switched between authorized approved roles'
    }
  ],

  // Courses with live attendance calculator
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
    { id: 'route_1', name: 'Route 1: Dindigul Railway Jn ↔ GRI Main Gate', busNo: 'TN-57-N-2418', driver: 'M. Murugesan', phone: '+91 94431 82410', eta: '8 mins', progress: 68, status: 'Approaching Chinnalapatti Four-Roads' },
    { id: 'route_2', name: 'Route 2: Madurai Periyar Bus Stand ↔ GRI', busNo: 'TN-57-N-3102', driver: 'S. Palanichamy', phone: '+91 98421 95430', eta: '22 mins', progress: 35, status: 'Crossed Vadipatti Toll Plaza' },
    { id: 'route_3', name: 'Route 3: Batlagundu Bus Terminus ↔ GRI', busNo: 'TN-57-N-1894', driver: 'K. Vellingiri', phone: '+91 97880 14209', eta: '14 mins', progress: 82, status: 'Entering University South Gate' }
  ],

  // Grievances
  grievances: [
    { id: 'GRI-2026-TKT-8912', category: 'Infrastructure & Labs', subject: 'High-speed Wi-Fi access point in Computer Science Block Lab 3', date: '22 Sep 2026', status: 'RESOLVED', remarks: 'Access Point replaced and calibrated by Central Computer Centre.' },
    { id: 'GRI-2026-TKT-9204', category: 'Hostel & Mess', subject: 'Drinking water RO plant scheduled maintenance in Thamarai Illam', date: '23 Sep 2026', status: 'IN_PROGRESS', remarks: 'Estate maintenance team assigned; filter replacement underway today.' }
  ],

  // Statutory Circulars
  circulars: [
    { id: 'CIR-2026-NOV-01', title: 'Samarth@GRI Semester Examination Hall Tickets Released', category: 'Examinations', date: '24 Sep 2026', issuedBy: 'Controller of Examinations', urgent: true, summary: 'Candidates appearing for Nov/Dec 2026 End Semester Examinations can download verified hall tickets with e-SANAD QR tokens.' },
    { id: 'CIR-2026-NOV-02', title: 'Nai Talim Village Internship Fieldwork Orientation', category: 'Academics', date: '21 Sep 2026', issuedBy: 'Dean of Academic Affairs', urgent: false, summary: 'Mandatory rural development orientation for postgraduate students at Kasturba Hospital and Gandhigram Seva Ashram.' },
    { id: 'CIR-2026-NOV-03', title: 'e-SANAD Digital Transcripts & Degree Verification Service', category: 'Administration', date: '18 Sep 2026', issuedBy: "Registrar's Secretariat", urgent: false, summary: 'University degree records and mark transcripts are now integrated with National Academic Depository (NAD) and DigiLocker.' }
  ],

  // Sahayak AI
  sahayakMessages: [
    { isBot: true, text: "Vanakkam! I am GRI-Sahayak, your institutional AI guide for The Gandhigram Rural Institute (Deemed to be University). Ask me about Admissions 2026, CBCS courses, examination hall tickets, 75% attendance criteria, hostels, or campus transit.", source: 'ruraluniv.ac.in • Official UGC Registry' }
  ]
};

// Set default current user to Admin
state.currentUser = state.accounts[0];

// --- 3. Authorization & Permissions Engine ---
function checkPermission(permissionName) {
  if (!state.currentUser) return permissionName === PERMISSIONS.VIEW_PUBLIC;
  if (state.currentUser.status !== 'APPROVED') {
    return permissionName === PERMISSIONS.VIEW_PUBLIC || permissionName === PERMISSIONS.USE_SAHAYAK_AI;
  }
  const role = state.currentUser.activeRole || 'GUEST';
  const allowedPermissions = ROLE_PERMISSIONS_MAP[role] || [];
  return allowedPermissions.includes(permissionName);
}

// --- 4. Haptic Feedback ---
class HapticFeedback {
  static click() { if (navigator.vibrate) navigator.vibrate(10); }
  static success() { if (navigator.vibrate) navigator.vibrate([15, 50, 20]); }
  static error() { if (navigator.vibrate) navigator.vibrate([40, 40, 40]); }
}

// --- 5. DOM Cache ---
const el = {
  simulatorWrapper: document.getElementById('simulatorWrapper'),
  mobileFrameContainer: document.getElementById('mobileFrameContainer'),
  mobileScreen: document.getElementById('mobileScreen'),
  toggleDeviceFrameBtn: document.getElementById('toggleDeviceFrameBtn'),
  toggleGlobalThemeBtn: document.getElementById('toggleGlobalThemeBtn'),
  themeBtnText: document.getElementById('themeBtnText'),
  quickSyncBtn: document.getElementById('quickSyncBtn'),
  globalAccountSelect: document.getElementById('globalAccountSelect'),
  openRegisterBtn: document.getElementById('openRegisterBtn'),
  currentRoleChip: document.getElementById('currentRoleChip'),
  roleBadgeBtn: document.getElementById('roleBadgeBtn'),
  statusClock: document.getElementById('statusClock'),
  bottomNav: document.getElementById('bottomNav'),
  toastContainer: document.getElementById('toastContainer'),
  
  // Modals
  authModal: document.getElementById('authModal'),
  closeAuthBtn: document.getElementById('closeAuthBtn'),
  loginForm: document.getElementById('loginForm'),
  loginEmail: document.getElementById('loginEmail'),
  loginPassword: document.getElementById('loginPassword'),
  quickAuthButtonsGrid: document.getElementById('quickAuthButtonsGrid'),
  linkOpenRegister: document.getElementById('linkOpenRegister'),
  linkPublicVisitor: document.getElementById('linkPublicVisitor'),

  registerModal: document.getElementById('registerModal'),
  closeRegisterBtn: document.getElementById('closeRegisterBtn'),
  registrationWizardForm: document.getElementById('registrationWizardForm'),
  stepIndicator1: document.getElementById('stepIndicator1'),
  stepIndicator2: document.getElementById('stepIndicator2'),
  stepIndicator3: document.getElementById('stepIndicator3'),
  regStep1: document.getElementById('regStep1'),
  regStep2: document.getElementById('regStep2'),
  regStep3: document.getElementById('regStep3'),
  btnNextToStep2: document.getElementById('btnNextToStep2'),
  btnNextToStep3: document.getElementById('btnNextToStep3'),
  btnBackToStep1: document.getElementById('btnBackToStep1'),
  btnBackToStep2: document.getElementById('btnBackToStep2'),
  dynamicRoleFieldsContainer: document.getElementById('dynamicRoleFieldsContainer'),

  adminReviewModal: document.getElementById('adminReviewModal'),
  closeAdminReviewBtn: document.getElementById('closeAdminReviewBtn'),
  adminReviewDetails: document.getElementById('adminReviewDetails'),
  reviewSubtitle: document.getElementById('reviewSubtitle'),

  roleSwitcherModal: document.getElementById('roleSwitcherModal'),
  closeRoleSwitcherBtn: document.getElementById('closeRoleSwitcherBtn'),
  authorizedRolesList: document.getElementById('authorizedRolesList'),

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
  screenAdmin: document.getElementById('screenAdmin'),
  screenStatus: document.getElementById('screenStatus'),
  screenApprovals: document.getElementById('screenApprovals'),
  screenCoe: document.getElementById('screenCoe'),
  screenScholar: document.getElementById('screenScholar'),
  screenFaculty: document.getElementById('screenFaculty')
};

// --- 6. Live Clock Updater ---
function updateClock() {
  const now = new Date();
  let hours = now.getHours();
  const mins = String(now.getMinutes()).padStart(2, '0');
  el.statusClock.textContent = `${hours}:${mins}`;
}
setInterval(updateClock, 1000);
updateClock();

// --- 7. Toast Alerts ---
function showToast(message, type = 'success') {
  if (type === 'error') HapticFeedback.error();
  else HapticFeedback.click();

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

// --- 8. 3D Card Tilt Interaction ---
function attach3DTiltHandlers() {
  document.querySelectorAll('.tilt-card').forEach(card => {
    card.addEventListener('mousemove', e => {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left - rect.width / 2;
      const y = e.clientY - rect.top - rect.height / 2;
      const rotateX = -(y / (rect.height / 2)) * 5;
      const rotateY = (x / (rect.width / 2)) * 5;
      card.style.transform = `perspective(1000px) rotateX(${rotateX.toFixed(2)}deg) rotateY(${rotateY.toFixed(2)}deg) translateY(-2px)`;
    });
    card.addEventListener('mouseleave', () => {
      card.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg) translateY(0)';
    });
  });
}

// --- 9. Dynamic Navigation Renderer ---
function updateDynamicNavigation() {
  const u = state.currentUser;
  const isApproved = u && u.status === 'APPROVED';
  const role = isApproved ? u.activeRole : (u ? u.status : 'PUBLIC');

  // Determine accessible tabs
  let navItems = [];

  if (!u || u.status === 'PUBLIC') {
    navItems = [
      { id: 'home', label: 'Home', icon: '<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>' },
      { id: 'campus', label: 'Campus', icon: '<path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>' },
      { id: 'gazettes', label: 'Gazettes', icon: '<path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>' },
      { id: 'auth', label: 'Sign In', icon: '<path d="M10.09 15.59L11.5 17l5-5-5-5-1.41 1.41L12.67 11H3v2h9.67l-2.58 2.59zM19 3H5c-1.11 0-2 .9-2 2v4h2V5h14v14H5v-4H3v4c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.89-2-2-2z"/>' }
    ];
  } else if (u.status === 'PENDING' || u.status === 'UNDER_REVIEW' || u.status === 'REJECTED' || u.status === 'SUSPENDED') {
    navItems = [
      { id: 'status', label: 'Status', icon: '<path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/>' },
      { id: 'home', label: 'Campus Info', icon: '<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>' },
      { id: 'auth', label: 'Accounts', icon: '<path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>' }
    ];
  } else if (role === 'STUDENT') {
    navItems = [
      { id: 'home', label: 'Home', icon: '<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>' },
      { id: 'academics', label: 'Academics', icon: '<path d="M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/>' },
      { id: 'campus', label: 'Transit', icon: '<path d="M12 2c-4.42 0-8 .5-8 4v10c0 .88.39 1.67 1 2.22V20c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h8v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1.78c.61-.55 1-1.34 1-2.22V6c0-3.5-3.58-4-8-4z"/>' },
      { id: 'services', label: 'Services', icon: '<path d="M4 8h4V4H4v4zm6 12h4v-4h-4v4zm-6 0h4v-4H4v4zm0-6h4v-4H4v4zm6 0h4v-4h-4v4zm6-10v4h4V4h-4zm-6 4h4V4h-4v4zm6 6h4v-4h-4v4zm0 6h4v-4h-4v4z"/>' }
    ];
  } else if (role === 'FACULTY') {
    navItems = [
      { id: 'home', label: 'Faculty Hub', icon: '<path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>' },
      { id: 'faculty', label: 'Teaching', icon: '<path d="M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/>' },
      { id: 'campus', label: 'Campus', icon: '<path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>' },
      { id: 'gazettes', label: 'Orders', icon: '<path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>' }
    ];
  } else if (role === 'COE_STAFF') {
    navItems = [
      { id: 'home', label: 'CoE Hub', icon: '<path d="M22 10V6c0-1.11-.9-2-2-2H4c-1.1 0-1.99.89-1.99 2v4c1.1 0 1.99.9 1.99 2s-.89 2-2 2v4c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2v-4c-1.1 0-2-.9-2-2s.9-2 2-2z"/>' },
      { id: 'coe', label: 'Exam Ops', icon: '<path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>' },
      { id: 'campus', label: 'Campus', icon: '<path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>' },
      { id: 'admin', label: 'Notices', icon: '<path d="M19.43 12.98c.04-.32.07-.64.07-.98s-.03-.66-.07-.98l2.11-1.65c.19-.15.24-.42.12-.64l-2-3.46c-.12-.22-.39-.3-.61-.22l-2.49 1c-.52-.4-1.08-.73-1.69-.98l-.38-2.65C14.46 2.18 14.25 2 14 2h-4c-.25 0-.46.18-.49.42l-.38 2.65c-.61.25-1.17.59-1.69.98l-2.49-1c-.23-.09-.49 0-.61.22l-2 3.46c-.13.22-.07.49.12.64l2.11 1.65c-.04.32-.07.65-.07.98s.03.66.07.98l-2.11 1.65c-.19.15-.24.42-.12.64l2 3.46c.12.22.39.3.61.22l2.49-1c.52.4 1.08.73 1.69.98l.38 2.65c.03.24.24.42.49.42h4c.25 0 .46-.18.49-.42l.38-2.65c.61-.25 1.17-.59 1.69-.98l2.49 1c.23.09.49 0 .61-.22l2-3.46c.12-.22.07-.49-.12-.64l-2.11-1.65zM12 15.5c-1.93 0-3.5-1.57-3.5-3.5s1.57-3.5 3.5-3.5 3.5 1.57 3.5 3.5-1.57 3.5-3.5 3.5z"/>' }
    ];
  } else if (role === 'SCHOLAR') {
    navItems = [
      { id: 'home', label: 'Scholar Hub', icon: '<path d="M12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/>' },
      { id: 'scholar', label: 'Research', icon: '<path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H8V4h12v12z"/>' },
      { id: 'campus', label: 'Library', icon: '<path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>' },
      { id: 'services', label: 'Care', icon: '<path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z"/>' }
    ];
  } else if (role === 'ADMIN') {
    navItems = [
      { id: 'home', label: 'Dashboard', icon: '<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>' },
      { id: 'approvals', label: 'Approvals', icon: '<path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>' },
      { id: 'admin', label: 'Registry', icon: '<path d="M19.43 12.98c.04-.32.07-.64.07-.98s-.03-.66-.07-.98l2.11-1.65c.19-.15.24-.42.12-.64l-2-3.46c-.12-.22-.39-.3-.61-.22l-2.49 1c-.52-.4-1.08-.73-1.69-.98l-.38-2.65C14.46 2.18 14.25 2 14 2h-4c-.25 0-.46.18-.49.42l-.38 2.65c-.61.25-1.17.59-1.69.98l-2.49-1c-.23-.09-.49 0-.61.22l-2 3.46c-.13.22-.07.49.12.64l2.11 1.65c-.04.32-.07.65-.07.98s.03.66.07.98l-2.11 1.65c-.19.15-.24.42-.12.64l2 3.46c.12.22.39.3.61.22l2.49-1c.52.4 1.08.73 1.69.98l.38 2.65c.03.24.24.42.49.42h4c.25 0 .46-.18.49-.42l.38-2.65c.61-.25 1.17-.59 1.69-.98l2.49 1c.23.09.49 0 .61-.22l2-3.46c.12-.22.07-.49-.12-.64l-2.11-1.65zM12 15.5c-1.93 0-3.5-1.57-3.5-3.5s1.57-3.5 3.5-3.5 3.5 1.57 3.5 3.5-1.57 3.5-3.5 3.5z"/>' },
      { id: 'campus', label: 'Transit', icon: '<path d="M12 2c-4.42 0-8 .5-8 4v10c0 .88.39 1.67 1 2.22V20c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h8v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1.78c.61-.55 1-1.34 1-2.22V6c0-3.5-3.58-4-8-4z"/>' }
    ];
  }

  // Render bottom nav HTML
  el.bottomNav.innerHTML = navItems.map(item => `
    <button class="nav-item ${state.currentTab === item.id ? 'active' : ''}" data-tab="${item.id}" id="nav_${item.id}">
      <div class="nav-icon-wrap">
        <svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor">${item.icon}</svg>
      </div>
      <span class="nav-label">${item.label}</span>
    </button>
  `).join('');

  // Re-attach bottom nav clicks
  document.querySelectorAll('.nav-item').forEach(btn => {
    btn.addEventListener('click', () => {
      const tab = btn.getAttribute('data-tab');
      if (tab === 'auth') {
        openAuthModal();
      } else if (tab === 'gazettes') {
        openDocCenterModal();
      } else {
        switchTab(tab);
      }
    });
  });

  // Update top role badge chip
  if (!u || u.status === 'PUBLIC') {
    el.currentRoleChip.textContent = 'PUBLIC';
    el.currentRoleChip.style.color = 'var(--color-text-muted)';
  } else if (u.status !== 'APPROVED') {
    el.currentRoleChip.textContent = u.status;
    el.currentRoleChip.style.color = u.status === 'PENDING' ? 'var(--color-warning)' : 'var(--color-info)';
  } else {
    el.currentRoleChip.textContent = u.activeRole;
    el.currentRoleChip.style.color = 'var(--color-primary)';
  }
}

// --- 10. Switch Tab Engine with Permission Gate ---
function switchTab(tabId) {
  HapticFeedback.click();

  // If user is unapproved and tries to access protected tab -> redirect to status screen
  if (state.currentUser && state.currentUser.status !== 'APPROVED') {
    if (tabId !== 'status' && tabId !== 'home') {
      tabId = 'status';
      showToast('Account is pending approval. Showing registration status.', 'info');
    }
  }

  // Permission Gate
  if (tabId === 'approvals' && !checkPermission(PERMISSIONS.APPROVE_REJECT_APPLICATIONS)) {
    showToast('Unauthorized: Administrator approval permission required.', 'error');
    return;
  }
  if (tabId === 'admin' && !checkPermission(PERMISSIONS.VIEW_ADMIN_DASHBOARD) && !checkPermission(PERMISSIONS.PUBLISH_STATUTORY_CIRCULARS)) {
    showToast('Unauthorized: Institutional admin access required.', 'error');
    return;
  }

  state.currentTab = tabId;

  // Update bottom nav active state
  document.querySelectorAll('.nav-item').forEach(btn => {
    btn.classList.toggle('active', btn.getAttribute('data-tab') === tabId);
  });

  // Update screen visibility
  document.querySelectorAll('.screen-view').forEach(view => {
    view.classList.toggle('active', view.getAttribute('data-screen') === tabId);
  });

  // Render content
  if (tabId === 'home') renderHomeScreen();
  else if (tabId === 'status') renderStatusScreen();
  else if (tabId === 'approvals') renderApprovalsScreen();
  else if (tabId === 'academics') renderAcademicsScreen();
  else if (tabId === 'campus') renderCampusScreen();
  else if (tabId === 'services') renderServicesScreen();
  else if (tabId === 'admin') renderAdminScreen();
  else if (tabId === 'coe') renderCoeScreen();
  else if (tabId === 'scholar') renderScholarScreen();
  else if (tabId === 'faculty') renderFacultyScreen();
}

// --- 11. Authentication & Session Engine ---
function authenticateUser(userAccountId) {
  const account = state.accounts.find(a => a.id === userAccountId);
  if (!account) return;

  state.currentUser = account;
  el.globalAccountSelect.value = userAccountId;
  HapticFeedback.success();

  if (account.status === 'APPROVED') {
    showToast(`Signed in as ${account.name} (${account.activeRole})`);
    state.currentTab = 'home';
  } else {
    showToast(`Account status: ${account.status.replace('_', ' ')}`, 'info');
    state.currentTab = 'status';
  }

  updateDynamicNavigation();
  switchTab(state.currentTab);
}

function openAuthModal() {
  HapticFeedback.click();
  renderQuickAuthButtons();
  el.authModal.classList.add('active');
}

function closeAuthModal() {
  el.authModal.classList.remove('active');
}

function renderQuickAuthButtons() {
  el.quickAuthButtonsGrid.innerHTML = state.accounts.map(acc => `
    <button class="btn btn-sm ${acc.id === state.currentUser?.id ? 'btn-primary' : 'btn-outline'} btn-quick-auth" data-id="${acc.id}" style="text-align: left; padding: 6px 8px; font-size: 10px;">
      <div style="font-weight: 700; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">${acc.name.split(' ')[0]} (${acc.activeRole || acc.status})</div>
      <div style="font-size: 9px; opacity: 0.8;">Status: ${acc.status}</div>
    </button>
  `).join('');

  document.querySelectorAll('.btn-quick-auth').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const id = e.currentTarget.getAttribute('data-id');
      authenticateUser(id);
      closeAuthModal();
    });
  });
}

// --- 12. Registration & Institutional Approval Workflow ---
function openRegisterModal() {
  HapticFeedback.click();
  el.registrationWizardForm.reset();
  showRegisterStep(1);
  renderDynamicRoleFields('STUDENT');
  el.registerModal.classList.add('active');
}

function closeRegisterModal() {
  el.registerModal.classList.remove('active');
}

function showRegisterStep(stepNum) {
  el.stepIndicator1.classList.toggle('active', stepNum >= 1);
  el.stepIndicator2.classList.toggle('active', stepNum >= 2);
  el.stepIndicator3.classList.toggle('active', stepNum >= 3);

  el.regStep1.style.display = stepNum === 1 ? 'block' : 'none';
  el.regStep2.style.display = stepNum === 2 ? 'block' : 'none';
  el.regStep3.style.display = stepNum === 3 ? 'block' : 'none';
}

function renderDynamicRoleFields(role) {
  let fieldsHtml = '';
  if (role === 'STUDENT') {
    fieldsHtml = `
      <div class="form-group">
        <label class="form-label">Student Register / Roll Number</label>
        <input type="text" class="form-input" id="dynInstId" placeholder="e.g. 26MCA018" required>
      </div>
      <div class="form-group">
        <label class="form-label">Academic Department</label>
        <select class="form-select" id="dynDept">
          <option value="Computer Science & Applications">Computer Science & Applications</option>
          <option value="Rural Development & Extension">Rural Development & Extension</option>
          <option value="School of Agriculture & Animal Husbandry">School of Agriculture & Animal Husbandry</option>
          <option value="Chemistry & Renewable Energy">Chemistry & Renewable Energy</option>
          <option value="Faculty of Rural Social Sciences">Faculty of Rural Social Sciences</option>
        </select>
      </div>
      <div class="form-group">
        <label class="form-label">Degree Programme & Semester</label>
        <input type="text" class="form-input" id="dynProgram" placeholder="e.g. Master of Computer Applications • Semester I" required>
      </div>
    `;
  } else if (role === 'FACULTY') {
    fieldsHtml = `
      <div class="form-group">
        <label class="form-label">Faculty Employee ID</label>
        <input type="text" class="form-input" id="dynInstId" placeholder="e.g. FAC-CS-204" required>
      </div>
      <div class="form-group">
        <label class="form-label">School / Department</label>
        <input type="text" class="form-input" id="dynDept" placeholder="e.g. School of Sciences" required>
      </div>
      <div class="form-group">
        <label class="form-label">Academic Designation</label>
        <input type="text" class="form-input" id="dynProgram" placeholder="e.g. Assistant Professor (Stage II)" required>
      </div>
    `;
  } else if (role === 'COE_STAFF') {
    fieldsHtml = `
      <div class="form-group">
        <label class="form-label">CoE Staff ID</label>
        <input type="text" class="form-input" id="dynInstId" placeholder="e.g. COE-TAB-14" required>
      </div>
      <div class="form-group">
        <label class="form-label">Office Branch / Section</label>
        <input type="text" class="form-input" id="dynDept" placeholder="e.g. End Semester Tabulation & Hall Tickets" required>
      </div>
      <div class="form-group">
        <label class="form-label">Staff Designation</label>
        <input type="text" class="form-input" id="dynProgram" placeholder="e.g. Section Superintendent" required>
      </div>
    `;
  } else if (role === 'SCHOLAR') {
    fieldsHtml = `
      <div class="form-group">
        <label class="form-label">Doctoral Scholar Registration No</label>
        <input type="text" class="form-input" id="dynInstId" placeholder="e.g. 26PHD-ENG-03" required>
      </div>
      <div class="form-group">
        <label class="form-label">Research Department</label>
        <input type="text" class="form-input" id="dynDept" placeholder="e.g. Department of English & Foreign Languages" required>
      </div>
      <div class="form-group">
        <label class="form-label">Research Guide / Specialization</label>
        <input type="text" class="form-input" id="dynProgram" placeholder="e.g. Guide: Dr. S. Kanthimathi • Gandhian Literature" required>
      </div>
    `;
  } else {
    fieldsHtml = `
      <div class="form-group">
        <label class="form-label">Affiliation / Purpose of Visit</label>
        <input type="text" class="form-input" id="dynProgram" placeholder="e.g. Prospective Applicant / Research Collaboration" required>
      </div>
    `;
  }

  el.dynamicRoleFieldsContainer.innerHTML = fieldsHtml;
}

// --- 13. Screen Renderers ---

// Screen 1: Home Dashboard (Intelligent Role-Aware Dashboard)
function renderHomeScreen() {
  const u = state.currentUser || state.accounts[1];
  const isStudent = u.activeRole === 'STUDENT';
  const isAdmin = u.activeRole === 'ADMIN';
  const isFaculty = u.activeRole === 'FACULTY';
  const isCoE = u.activeRole === 'COE_STAFF';

  el.screenHome.innerHTML = `
    <!-- Hero Identity Card -->
    <div class="card hero-student-card tilt-card" id="heroStudentCard">
      <div class="hero-profile-row">
        <div class="student-meta-info">
          <h1>${u.name}</h1>
          <div class="student-sub">${u.institutionalId || 'GRI-MEMBER'} • ${u.program || u.activeRole}</div>
          <div class="student-dept">${u.department || 'The Gandhigram Rural Institute'}</div>
        </div>
        <div class="student-avatar-wrap">
          <img src="/assets/${isStudent ? 'student_avatar.jpg' : 'gri_official_logo.png'}" alt="${u.name}" class="student-avatar-img">
          <span class="hero-badge-live">VERIFIED</span>
        </div>
      </div>
      <div class="hero-stats-row">
        <div class="mini-stat-col">
          <span class="mini-stat-label">Active Role</span>
          <span class="mini-stat-val highlight">${u.activeRole}</span>
        </div>
        <div class="mini-stat-col">
          <span class="mini-stat-label">Approval Status</span>
          <span class="mini-stat-val" style="color: var(--color-success);">✓ ${u.status}</span>
        </div>
        <div class="mini-stat-col">
          <span class="mini-stat-label">Authorized Roles</span>
          <span class="mini-stat-val" style="font-size: 11px;">${u.approvedRoles.join(', ')}</span>
        </div>
      </div>
    </div>

    ${isAdmin ? `
      <!-- Admin Governance Quick Launch Bar -->
      <div class="card tilt-card" style="border-left: 4px solid var(--color-primary); background: linear-gradient(135deg, var(--color-surface-card), var(--color-surface-elevated));">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div>
            <h3 style="font-family: var(--font-display); font-size: 14px; font-weight: 700;">Institutional Registration & Role Approvals</h3>
            <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">
              ${state.accounts.filter(a => a.status === 'PENDING').length} Pending • ${state.accounts.filter(a => a.status === 'UNDER_REVIEW').length} Under Review
            </p>
          </div>
          <button class="btn btn-sm btn-primary" id="btnGoToApprovals">Open Approval Center →</button>
        </div>
      </div>
    ` : ''}

    ${isStudent ? `
      <!-- Biometric Attendance Donut Card -->
      <div class="card attendance-widget-card tilt-card">
        <div class="progress-donut-wrap">
          <svg class="donut-svg" viewBox="0 0 72 72">
            <circle class="donut-bg" cx="36" cy="36" r="32"></circle>
            <circle class="donut-fill" cx="36" cy="36" r="32" style="stroke-dashoffset: ${(1 - (u.attendance || 88.5) / 100) * 201};"></circle>
          </svg>
          <div class="donut-label-center">
            <span class="donut-percent">${u.attendance || 88.5}%</span>
            <span class="donut-sub">UGC Safe</span>
          </div>
        </div>
        <div class="attendance-details-col">
          <h3 class="attendance-title">Smart Attendance Ledger</h3>
          <p class="attendance-desc">All courses fulfill the mandatory 75% CBCS examination criteria.</p>
          <div class="attendance-status-badge">
            <svg viewBox="0 0 24 24" width="12" height="12" fill="currentColor"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
            Biometric Check-in Safe Zone
          </div>
        </div>
      </div>
    ` : ''}

    <!-- Quick Action Grid -->
    <div class="section-header-row">
      <span class="section-title">Institutional Portals & Services</span>
    </div>

    <div class="quick-action-grid">
      ${checkPermission(PERMISSIONS.VIEW_HALL_TICKET) ? `
        <button class="action-card-btn" id="btnQuickHallTicket">
          <div class="action-icon-circle">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M22 10V6c0-1.11-.9-2-2-2H4c-1.1 0-1.99.89-1.99 2v4c1.1 0 1.99.9 1.99 2s-.89 2-2 2v4c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2v-4c-1.1 0-2-.9-2-2s.9-2 2-2z"/></svg>
          </div>
          <span class="action-btn-label">Hall Ticket</span>
        </button>
      ` : ''}

      ${checkPermission(PERMISSIONS.FILE_GRIEVANCE) ? `
        <button class="action-card-btn" id="btnQuickGrievance">
          <div class="action-icon-circle">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
          </div>
          <span class="action-btn-label">GRI-Care</span>
        </button>
      ` : ''}

      ${checkPermission(PERMISSIONS.VIEW_TRANSIT_RADAR) ? `
        <button class="action-card-btn" id="btnQuickBus">
          <div class="action-icon-circle">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 2c-4.42 0-8 .5-8 4v10c0 .88.39 1.67 1 2.22V20c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h8v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1.78c.61-.55 1-1.34 1-2.22V6c0-3.5-3.58-4-8-4z"/></svg>
          </div>
          <span class="action-btn-label">Transit Radar</span>
        </button>
      ` : ''}

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

      ${checkPermission(PERMISSIONS.VIEW_DIGITAL_ID) ? `
        <button class="action-card-btn" id="btnQuickIDCard">
          <div class="action-icon-circle">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2z"/></svg>
          </div>
          <span class="action-btn-label">Digital ID</span>
        </button>
      ` : `
        <button class="action-card-btn" id="btnQuickAuthAction">
          <div class="action-icon-circle">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
          </div>
          <span class="action-btn-label">User Status</span>
        </button>
      `}
    </div>

    <!-- Official Notices Feed -->
    <div class="section-header-row">
      <span class="section-title">University Circulars & Statutory Orders</span>
      <a href="#" class="section-action-link" id="homeViewGazettesLink">View all</a>
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

  // Attach button events
  document.getElementById('btnGoToApprovals')?.addEventListener('click', () => switchTab('approvals'));
  document.getElementById('btnQuickHallTicket')?.addEventListener('click', openHallTicketModal);
  document.getElementById('btnQuickGrievance')?.addEventListener('click', () => switchTab('services'));
  document.getElementById('btnQuickBus')?.addEventListener('click', () => switchTab('campus'));
  document.getElementById('btnQuickSahayak')?.addEventListener('click', openSahayakModal);
  document.getElementById('btnQuickDocCenter')?.addEventListener('click', openDocCenterModal);
  document.getElementById('btnQuickIDCard')?.addEventListener('click', () => switchTab('services'));
  document.getElementById('btnQuickAuthAction')?.addEventListener('click', openAuthModal);
  document.getElementById('homeViewGazettesLink')?.addEventListener('click', (e) => {
    e.preventDefault();
    openDocCenterModal();
  });

  attach3DTiltHandlers();
}

// Screen 6: Dedicated Application Status Dashboard
function renderStatusScreen() {
  const u = state.currentUser;
  if (!u) {
    switchTab('home');
    return;
  }

  const isPending = u.status === 'PENDING';
  const isReview = u.status === 'UNDER_REVIEW';
  const isRejected = u.status === 'REJECTED';
  const isSuspended = u.status === 'SUSPENDED';

  let statusTitle = 'Application Status';
  let badgeClass = 'pending';
  if (isPending) { statusTitle = 'Pending Institutional Verification'; badgeClass = 'pending'; }
  else if (isReview) { statusTitle = 'Additional Information Required'; badgeClass = 'under_review'; }
  else if (isRejected) { statusTitle = 'Application Not Approved'; badgeClass = 'rejected'; }
  else if (isSuspended) { statusTitle = 'Account Suspended'; badgeClass = 'suspended'; }

  el.screenStatus.innerHTML = `
    <div class="card tilt-card" style="text-align: center; padding: var(--space-lg) var(--space-md);">
      <div style="width: 56px; height: 56px; border-radius: 50%; background: var(--color-${badgeClass}-bg, var(--color-surface-elevated)); color: var(--color-${badgeClass}, var(--color-primary)); display: flex; align-items: center; justify-content: center; margin: 0 auto 12px;">
        <svg viewBox="0 0 24 24" width="28" height="28" fill="currentColor">
          ${isPending ? '<path d="M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10 10-4.5 10-10S17.5 2 12 2zm1 14h-2v-2h2v2zm0-4h-2V7h2v5z"/>' : ''}
          ${isReview ? '<path d="M11 17h2v-6h-2v6zm1-15C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zM11 9h2V7h-2v2z"/>' : ''}
          ${isRejected ? '<path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 13.59L15.59 17 12 13.41 8.41 17 7 15.59 10.59 12 7 8.41 8.41 7 12 10.59 15.59 7 17 8.41 13.41 12 17 15.59z"/>' : ''}
          ${isSuspended ? '<path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/>' : ''}
        </svg>
      </div>

      <span class="status-badge-pill ${badgeClass}">${u.status.replace('_', ' ')}</span>
      <h2 style="font-family: var(--font-display); font-size: 17px; font-weight: 700; margin-top: 8px;">${statusTitle}</h2>
      <p style="font-size: 12px; color: var(--color-text-secondary); margin-top: 4px;">
        Application Ref: <strong style="font-family: var(--font-mono); color: var(--color-primary);">${u.applicationId || 'GRI-2026-APP-8104'}</strong>
      </p>
    </div>

    <!-- Verification Timeline -->
    <div class="card tilt-card">
      <div style="font-size: 12px; font-weight: 700; color: var(--color-text-primary); margin-bottom: 8px;">Institutional Verification Timeline</div>
      <div class="status-timeline-track">
        <div class="status-step-node completed">
          <div class="step-circle">✓</div>
          <span class="step-node-label">Submitted</span>
        </div>
        <div class="status-step-node ${isPending || isReview ? 'current' : (isRejected ? '' : 'completed')}">
          <div class="step-circle">${isPending || isReview ? '2' : '✓'}</div>
          <span class="step-node-label">Registry Check</span>
        </div>
        <div class="status-step-node ${isReview ? 'current' : ''}">
          <div class="step-circle">3</div>
          <span class="step-node-label">Dean Review</span>
        </div>
        <div class="status-step-node">
          <div class="step-circle">4</div>
          <span class="step-node-label">Role Active</span>
        </div>
      </div>
    </div>

    <!-- Applicant Summary Details -->
    <div class="card tilt-card">
      <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; margin-bottom: 10px;">Registered Application Dossier</h4>
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; font-size: 11px;">
        <div><strong>Applicant Name:</strong> ${u.name}</div>
        <div><strong>Institutional ID:</strong> ${u.institutionalId || 'N/A'}</div>
        <div><strong>Requested Role:</strong> ${u.requestedRole || u.activeRole}</div>
        <div><strong>Department:</strong> ${u.department}</div>
        <div><strong>Programme:</strong> ${u.program || 'N/A'}</div>
        <div><strong>Submitted Date:</strong> ${u.submittedAt}</div>
      </div>
    </div>

    ${isReview ? `
      <!-- Additional Info Submission Box -->
      <div class="card tilt-card" style="border: 2px solid var(--color-info);">
        <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; color: var(--color-info); margin-bottom: 4px;">
          Administrative Query / Clarification Needed
        </h4>
        <p style="font-size: 12px; color: var(--color-text-secondary); background: var(--color-surface-elevated); padding: 8px; border-radius: 6px; margin-bottom: 10px;">
          "${u.infoRequested || 'Please provide your registered admission quota credentials.'}"
        </p>
        <form id="provideAdditionalInfoForm">
          <div class="form-group">
            <label class="form-label">Your Clarification & Document Details</label>
            <textarea class="form-textarea" id="applicantInfoResponse" placeholder="Enter requested certificate numbers, marks, or clarifications..." required></textarea>
          </div>
          <button type="submit" class="btn btn-primary btn-full">
            Submit Clarification to Registry →
          </button>
        </form>
      </div>
    ` : ''}

    ${isRejected ? `
      <div class="card tilt-card" style="border-left: 4px solid var(--color-error);">
        <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; color: var(--color-error);">Official Rejection Reason</h4>
        <p style="font-size: 12px; color: var(--color-text-secondary); margin-top: 4px;">
          "${u.rejectionReason || 'Institutional records did not match provided register credentials. Please contact Registrar office.'}"
        </p>
        <div style="margin-top: 10px;">
          <a href="mailto:registrar@ruraluniv.ac.in" class="btn btn-sm btn-outline">Email Registrar Helpdesk</a>
        </div>
      </div>
    ` : ''}

    <div style="display: flex; gap: 8px; margin-top: var(--space-md);">
      <button class="btn btn-outline btn-full" id="btnRefreshStatus">
        <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M12 4V1L8 5l4 4V6c3.31 0 6 2.69 6 6 0 1.01-.25 1.97-.7 2.8l1.46 1.46C19.54 15.03 20 13.57 20 12c0-4.42-3.58-8-8-8zm0 14c-3.31 0-6-2.69-6-6 0-1.01.25-1.97.7-2.8L5.24 7.74C4.46 8.97 4 10.43 4 12c0 4.42 3.58 8 8 8v3l4-4-4-4v3z"/></svg>
        Check Real-Time Status
      </button>
      <button class="btn btn-primary btn-full" id="btnSwitchToOtherAccount">Sign in as Other</button>
    </div>
  `;

  document.getElementById('btnRefreshStatus')?.addEventListener('click', () => {
    HapticFeedback.click();
    showToast('Registry synchronized. Account state refreshed.');
    renderStatusScreen();
  });

  document.getElementById('btnSwitchToOtherAccount')?.addEventListener('click', openAuthModal);

  const infoForm = document.getElementById('provideAdditionalInfoForm');
  if (infoForm) {
    infoForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const responseText = document.getElementById('applicantInfoResponse').value;
      u.infoProvided = responseText;
      u.status = 'UNDER_REVIEW';

      state.auditTrail.unshift({
        id: `aud_${Date.now()}`,
        timestamp: 'Just now',
        actor: `${u.name} (Applicant)`,
        targetUser: `${u.name} (${u.institutionalId})`,
        action: 'INFO_PROVIDED',
        previousStatus: 'INFO_REQUESTED',
        newStatus: 'UNDER_REVIEW',
        remarks: responseText
      });

      HapticFeedback.success();
      showToast('Additional documentation submitted to Dean Office!');
      renderStatusScreen();
    });
  }

  attach3DTiltHandlers();
}

// Screen 7: Registration & Role Approval Center (Admin Portal)
function renderApprovalsScreen() {
  if (!checkPermission(PERMISSIONS.APPROVE_REJECT_APPLICATIONS)) {
    showToast('Access denied: Administrator permissions required.', 'error');
    switchTab('home');
    return;
  }

  const pendingList = state.accounts.filter(a => a.status === 'PENDING');
  const reviewList = state.accounts.filter(a => a.status === 'UNDER_REVIEW');
  const approvedList = state.accounts.filter(a => a.status === 'APPROVED');
  const rejectedList = state.accounts.filter(a => a.status === 'REJECTED');

  el.screenApprovals.innerHTML = `
    <!-- Top Metrics Overview -->
    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 6px; margin-bottom: var(--space-md);">
      <div class="card" style="padding: 10px; margin-bottom: 0; text-align: center; border-bottom: 3px solid var(--color-warning);">
        <div style="font-family: var(--font-display); font-size: 18px; font-weight: 800; color: var(--color-warning);">${pendingList.length}</div>
        <div style="font-size: 9px; font-weight: 700; text-transform: uppercase;">Pending</div>
      </div>
      <div class="card" style="padding: 10px; margin-bottom: 0; text-align: center; border-bottom: 3px solid var(--color-info);">
        <div style="font-family: var(--font-display); font-size: 18px; font-weight: 800; color: var(--color-info);">${reviewList.length}</div>
        <div style="font-size: 9px; font-weight: 700; text-transform: uppercase;">Review</div>
      </div>
      <div class="card" style="padding: 10px; margin-bottom: 0; text-align: center; border-bottom: 3px solid var(--color-success);">
        <div style="font-family: var(--font-display); font-size: 18px; font-weight: 800; color: var(--color-success);">${approvedList.length}</div>
        <div style="font-size: 9px; font-weight: 700; text-transform: uppercase;">Approved</div>
      </div>
      <div class="card" style="padding: 10px; margin-bottom: 0; text-align: center; border-bottom: 3px solid var(--color-error);">
        <div style="font-family: var(--font-display); font-size: 18px; font-weight: 800; color: var(--color-error);">${rejectedList.length}</div>
        <div style="font-size: 9px; font-weight: 700; text-transform: uppercase;">Rejected</div>
      </div>
    </div>

    <!-- Search & Filter Controls -->
    <div style="display: flex; gap: 6px; margin-bottom: var(--space-sm);">
      <input type="text" class="form-input" id="approvalSearchInput" placeholder="Search applicant, ID, email, role..." style="padding: 8px 12px; font-size: 12px;">
    </div>

    <!-- Queue List -->
    <div class="section-header-row">
      <span class="section-title">Institutional Registration Applications</span>
      <span style="font-size: 11px; font-weight: 700; color: var(--color-primary);">Registry Queue</span>
    </div>

    <div id="approvalsListContainer">
      <!-- Populated below -->
    </div>
  `;

  renderApprovalQueueItems();

  document.getElementById('approvalSearchInput')?.addEventListener('input', (e) => {
    const q = e.target.value.toLowerCase();
    renderApprovalQueueItems(q);
  });
}

function renderApprovalQueueItems(searchQuery = '') {
  const container = document.getElementById('approvalsListContainer');
  if (!container) return;

  const filtered = state.accounts.filter(a => {
    if (!searchQuery) return true;
    return a.name.toLowerCase().includes(searchQuery) ||
           (a.institutionalId && a.institutionalId.toLowerCase().includes(searchQuery)) ||
           a.email.toLowerCase().includes(searchQuery) ||
           (a.requestedRole && a.requestedRole.toLowerCase().includes(searchQuery)) ||
           a.status.toLowerCase().includes(searchQuery);
  });

  if (filtered.length === 0) {
    container.innerHTML = `<div class="card" style="text-align: center; padding: var(--space-md); color: var(--color-text-muted);">No institutional applications matching criteria.</div>`;
    return;
  }

  container.innerHTML = filtered.map(app => `
    <div class="card applicant-card tilt-card" data-id="${app.id}">
      <div style="display: flex; justify-content: space-between; align-items: flex-start;">
        <div>
          <span class="status-badge-pill ${app.status.toLowerCase()}">${app.status.replace('_', ' ')}</span>
          <h4 style="font-family: var(--font-display); font-size: 14px; font-weight: 700; margin-top: 4px;">${app.name}</h4>
          <div style="font-size: 11px; color: var(--color-text-secondary);">
            Role: <strong>${app.requestedRole || app.activeRole}</strong> • ID: ${app.institutionalId || 'N/A'}
          </div>
          <div style="font-size: 10px; color: var(--color-text-muted); margin-top: 2px;">
            ${app.department} • Submitted: ${app.submittedAt}
          </div>
        </div>
        <button class="btn btn-sm btn-primary btn-inspect-app" data-id="${app.id}">Review Dossier →</button>
      </div>
    </div>
  `).join('');

  document.querySelectorAll('.btn-inspect-app').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      const id = e.currentTarget.getAttribute('data-id');
      openAdminReviewModal(id);
    });
  });

  attach3DTiltHandlers();
}

function openAdminReviewModal(accountId) {
  const app = state.accounts.find(a => a.id === accountId);
  if (!app) return;

  el.reviewSubtitle.textContent = `Dossier: ${app.name} (${app.institutionalId || app.id})`;

  el.adminReviewDetails.innerHTML = `
    <div class="card" style="background: var(--color-surface-elevated); margin-bottom: var(--space-sm);">
      <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
          <h3 style="font-family: var(--font-display); font-size: 16px; font-weight: 700;">${app.name}</h3>
          <div style="font-size: 12px; color: var(--color-text-secondary);">${app.email} • ${app.mobile}</div>
        </div>
        <span class="status-badge-pill ${app.status.toLowerCase()}">${app.status.replace('_', ' ')}</span>
      </div>
    </div>

    <div class="card" style="margin-bottom: var(--space-sm);">
      <h4 style="font-family: var(--font-display); font-size: 12px; font-weight: 700; text-transform: uppercase; color: var(--color-primary); margin-bottom: 8px;">Institutional Credentials</h4>
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; font-size: 11px;">
        <div><strong>Requested Role:</strong> ${app.requestedRole || app.activeRole}</div>
        <div><strong>Institutional ID:</strong> ${app.institutionalId || 'Pending'}</div>
        <div><strong>Department:</strong> ${app.department}</div>
        <div><strong>Programme:</strong> ${app.program || 'N/A'}</div>
        <div><strong>Submitted At:</strong> ${app.submittedAt}</div>
        <div><strong>Reviewed By:</strong> ${app.reviewedBy || 'Pending Action'}</div>
      </div>
    </div>

    ${app.infoRequested ? `
      <div class="card" style="border-left: 3px solid var(--color-info); margin-bottom: var(--space-sm);">
        <div style="font-size: 11px; font-weight: 700; color: var(--color-info);">Information Requested:</div>
        <div style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">${app.infoRequested}</div>
        ${app.infoProvided ? `<div style="font-size: 11px; color: var(--color-success); margin-top: 6px;"><strong>Applicant Response:</strong> ${app.infoProvided}</div>` : '<div style="font-size: 10px; color: var(--color-text-muted); margin-top: 4px;">Awaiting response from applicant.</div>'}
      </div>
    ` : ''}

    <!-- Decision Action Panel -->
    <div style="margin-top: var(--space-md); padding-top: var(--space-sm); border-top: 1px solid var(--color-surface-border);">
      <div style="font-size: 12px; font-weight: 700; margin-bottom: 8px;">Administrative Decision</div>
      <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 6px;">
        <button class="btn btn-sm btn-primary" id="btnAdminApprove" style="background: var(--color-success); border-color: var(--color-success);">
          ✓ Approve
        </button>
        <button class="btn btn-sm btn-outline" id="btnAdminRequestInfo">
          ? Request Info
        </button>
        <button class="btn btn-sm btn-outline" id="btnAdminReject" style="color: var(--color-error); border-color: var(--color-error);">
          ✕ Reject
        </button>
      </div>
    </div>

    <!-- Inline Action Forms (Hidden initially) -->
    <div id="adminActionFormContainer" style="margin-top: var(--space-sm);"></div>
  `;

  // Approve Handler
  document.getElementById('btnAdminApprove')?.addEventListener('click', () => {
    const roleToActivate = app.requestedRole || app.activeRole || 'STUDENT';
    const formBox = document.getElementById('adminActionFormContainer');
    formBox.innerHTML = `
      <div style="background: var(--color-success-bg); padding: 10px; border-radius: var(--radius-md); border: 1px solid var(--color-success);">
        <div style="font-size: 12px; font-weight: 700; color: var(--color-success);">Confirm Institutional Approval</div>
        <p style="font-size: 11px; color: var(--color-text-secondary); margin: 4px 0 8px;">
          Activating approved role <strong>${roleToActivate}</strong> for ${app.name}. Assigning institutional permissions.
        </p>
        <div style="display: flex; gap: 6px;">
          <button class="btn btn-sm btn-primary" id="btnConfirmApprovalAction">Confirm & Activate Role</button>
          <button class="btn btn-sm btn-outline" id="btnCancelAction">Cancel</button>
        </div>
      </div>
    `;

    document.getElementById('btnConfirmApprovalAction')?.addEventListener('click', () => {
      app.status = 'APPROVED';
      if (!app.approvedRoles.includes(roleToActivate)) {
        app.approvedRoles.push(roleToActivate);
      }
      app.activeRole = roleToActivate;
      app.reviewedAt = 'Just now';
      app.reviewedBy = state.currentUser.name;

      state.auditTrail.unshift({
        id: `aud_${Date.now()}`,
        timestamp: 'Just now',
        actor: `${state.currentUser.name} (ADMIN)`,
        targetUser: `${app.name} (${app.institutionalId})`,
        action: 'APPLICATION_APPROVED',
        previousStatus: 'PENDING',
        newStatus: 'APPROVED',
        remarks: `Role ${roleToActivate} activated with institutional permissions.`
      });

      HapticFeedback.success();
      showToast(`Account approved! Role ${roleToActivate} activated for ${app.name}.`);
      el.adminReviewModal.classList.remove('active');
      renderApprovalsScreen();
      renderAdminScreen();
    });

    document.getElementById('btnCancelAction')?.addEventListener('click', () => {
      formBox.innerHTML = '';
    });
  });

  // Request More Info Handler
  document.getElementById('btnAdminRequestInfo')?.addEventListener('click', () => {
    const formBox = document.getElementById('adminActionFormContainer');
    formBox.innerHTML = `
      <div style="background: var(--color-info-bg); padding: 10px; border-radius: var(--radius-md); border: 1px solid var(--color-info);">
        <div style="font-size: 12px; font-weight: 700; color: var(--color-info);">Request Specific Information / Documents</div>
        <textarea class="form-textarea" id="adminQueryText" placeholder="Specify document, certificate, or verification needed..." style="margin: 6px 0;"></textarea>
        <div style="display: flex; gap: 6px;">
          <button class="btn btn-sm btn-primary" id="btnSendQueryAction">Send Query to Applicant</button>
          <button class="btn btn-sm btn-outline" id="btnCancelAction2">Cancel</button>
        </div>
      </div>
    `;

    document.getElementById('btnSendQueryAction')?.addEventListener('click', () => {
      const q = document.getElementById('adminQueryText').value;
      if (!q.trim()) return;

      app.status = 'UNDER_REVIEW';
      app.infoRequested = q;
      app.reviewedAt = 'Just now';
      app.reviewedBy = state.currentUser.name;

      state.auditTrail.unshift({
        id: `aud_${Date.now()}`,
        timestamp: 'Just now',
        actor: `${state.currentUser.name} (ADMIN)`,
        targetUser: `${app.name} (${app.institutionalId})`,
        action: 'INFO_REQUESTED',
        previousStatus: 'PENDING',
        newStatus: 'UNDER_REVIEW',
        remarks: q
      });

      HapticFeedback.click();
      showToast('Information request dispatched to applicant.');
      el.adminReviewModal.classList.remove('active');
      renderApprovalsScreen();
    });

    document.getElementById('btnCancelAction2')?.addEventListener('click', () => {
      formBox.innerHTML = '';
    });
  });

  // Reject Handler
  document.getElementById('btnAdminReject')?.addEventListener('click', () => {
    const formBox = document.getElementById('adminActionFormContainer');
    formBox.innerHTML = `
      <div style="background: var(--color-error-bg); padding: 10px; border-radius: var(--radius-md); border: 1px solid var(--color-error);">
        <div style="font-size: 12px; font-weight: 700; color: var(--color-error);">Official Rejection Reason (Mandatory)</div>
        <input type="text" class="form-input" id="adminRejectReason" placeholder="e.g. Register number not found in Samarth 2026 roll" style="margin: 6px 0;">
        <div style="display: flex; gap: 6px;">
          <button class="btn btn-sm btn-primary" id="btnConfirmRejectAction" style="background: var(--color-error);">Confirm Rejection</button>
          <button class="btn btn-sm btn-outline" id="btnCancelAction3">Cancel</button>
        </div>
      </div>
    `;

    document.getElementById('btnConfirmRejectAction')?.addEventListener('click', () => {
      const r = document.getElementById('adminRejectReason').value;
      if (!r.trim()) {
        showToast('Please state a reason for rejection.', 'error');
        return;
      }

      app.status = 'REJECTED';
      app.rejectionReason = r;
      app.reviewedAt = 'Just now';
      app.reviewedBy = state.currentUser.name;

      state.auditTrail.unshift({
        id: `aud_${Date.now()}`,
        timestamp: 'Just now',
        actor: `${state.currentUser.name} (ADMIN)`,
        targetUser: `${app.name} (${app.institutionalId})`,
        action: 'APPLICATION_REJECTED',
        previousStatus: 'PENDING',
        newStatus: 'REJECTED',
        remarks: r
      });

      HapticFeedback.click();
      showToast('Application marked as REJECTED in Central Registry.');
      el.adminReviewModal.classList.remove('active');
      renderApprovalsScreen();
    });

    document.getElementById('btnCancelAction3')?.addEventListener('click', () => {
      formBox.innerHTML = '';
    });
  });

  el.adminReviewModal.classList.add('active');
}

// Screen 2: Academics Hub (For Approved Students & Scholars)
function renderAcademicsScreen() {
  if (!checkPermission(PERMISSIONS.VIEW_ACADEMICS)) {
    showToast('Unauthorized: Academic enrollment permissions required.', 'error');
    switchTab('home');
    return;
  }

  el.screenAcademics.innerHTML = `
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
            ${checkPermission(PERMISSIONS.MARK_STUDENT_ATTENDANCE) ? `
              <button class="btn btn-sm btn-outline btn-mark-att" data-code="${course.code}">Check-in</button>
            ` : ''}
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

    ${checkPermission(PERMISSIONS.VIEW_HALL_TICKET) ? `
      <div class="card" style="margin-top: var(--space-md); text-align: center; padding: var(--space-lg);">
        <h4 style="font-family: var(--font-display); font-size: 14px; margin-bottom: 6px;">End Semester Examinations (ESE) Nov/Dec 2026</h4>
        <p style="font-size: 11px; color: var(--color-text-secondary); margin-bottom: var(--space-md);">Cryptographic QR Hall Tickets authenticated by e-SANAD.</p>
        <button class="btn btn-primary" id="btnOpenHallTicketFromAcad">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M22 10V6c0-1.11-.9-2-2-2H4c-1.1 0-1.99.89-1.99 2v4c1.1 0 1.99.9 1.99 2s-.89 2-2 2v4c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2v-4c-1.1 0-2-.9-2-2z"/></svg>
          View e-SANAD Hall Ticket
        </button>
      </div>
    ` : ''}
  `;

  document.getElementById('btnOpenHallTicketFromAcad')?.addEventListener('click', openHallTicketModal);

  document.querySelectorAll('.btn-mark-att').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const code = e.currentTarget.getAttribute('data-code');
      showToast(`Biometric lecture check-in recorded for course ${code}.`);
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
      <div class="map-station-stop stop-start"></div>
      <div class="map-station-stop stop-mid"></div>
      <div class="map-station-stop stop-end"></div>
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

    <!-- Landmarks -->
    <div class="section-header-row" style="margin-top: var(--space-lg);">
      <span class="section-title">Key Campus Facilities</span>
    </div>

    <div class="card tilt-card">
      <h4 style="font-family: var(--font-display); font-size: 14px; font-weight: 700;">Dr. G. Ramachandran Central Library</h4>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">Over 1,75,000 volumes, rare Gandhian archives, RFID self-checkout kiosks.</p>
    </div>
  `;

  document.querySelectorAll('.btn-track-bus').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const id = e.currentTarget.getAttribute('data-id');
      const pin = document.getElementById('busRadarPin');
      if (pin) pin.style.left = (Math.random() * 60 + 20).toFixed(0) + '%';
      showToast(`Tracking live telemetry for ${id.toUpperCase()}`);
    });
  });

  attach3DTiltHandlers();
}

// Screen 4: Student Services & GRI-Care
function renderServicesScreen() {
  const u = state.currentUser;
  const hasDigitalId = checkPermission(PERMISSIONS.VIEW_DIGITAL_ID);

  el.screenServices.innerHTML = `
    ${hasDigitalId ? `
      <!-- 3D Flip Student ID Card -->
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
                <div class="id-student-roll">${u.institutionalId || u.id}</div>
                <div style="font-size: 10px; opacity: 0.9; margin-top: 2px;">${u.program || u.activeRole}</div>
              </div>
            </div>

            <div class="id-footer-row">
              <span>Valid Thru: ${u.validThru || '2026-12-31'}</span>
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
              <div>Hostel: ${u.hostelName || 'Day Scholar'}</div>
              <div>Transit: ${u.busPass || 'Standard Route'}</div>
              <div>Emergency: GRI Health Centre (+91 451 2452371)</div>
            </div>

            <!-- Barcode -->
            <div style="background: #fff; padding: 6px; border-radius: 4px; display: flex; flex-direction: column; align-items: center;">
              <div style="width: 100%; height: 26px; background: repeating-linear-gradient(90deg, #000 0, #000 2px, #fff 2px, #fff 5px);"></div>
              <span style="font-family: var(--font-mono); font-size: 9px; color: #000; margin-top: 2px;">*GRI-${u.institutionalId || 'ID'}-VERIFIED*</span>
            </div>
          </div>
        </div>
      </div>
    ` : ''}

    <!-- Zero Ragging & GRI-Care Form -->
    <div class="section-header-row" style="margin-top: var(--space-md);">
      <span class="section-title">GRI-Care Grievance Redressal</span>
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
          <input type="text" class="form-input" id="grievanceSubject" placeholder="Brief subject of grievance" required>
        </div>

        <div class="form-group">
          <label class="form-label">Detailed Description</label>
          <textarea class="form-textarea" id="grievanceDesc" placeholder="Provide full details, room number, or block location..." required></textarea>
        </div>

        <button type="submit" class="btn btn-primary btn-full">Register Statutory Grievance</button>
      </form>
    </div>

    <!-- Active Tickets -->
    <div class="section-header-row">
      <span class="section-title">My Registered Grievance Tickets</span>
    </div>

    ${state.grievances.map(g => `
      <div class="card tilt-card" style="border-left: 4px solid var(--color-${g.status === 'RESOLVED' ? 'success' : 'warning'});">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
          <div>
            <span class="course-code-badge">${g.id} • ${g.category}</span>
            <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; margin-top: 4px;">${g.subject}</h4>
          </div>
          <span class="role-pill-chip" style="background: var(--color-${g.status === 'RESOLVED' ? 'success-bg' : 'warning-bg'}); color: var(--color-${g.status === 'RESOLVED' ? 'success' : 'warning'});">${g.status}</span>
        </div>
        <div style="font-size: 11px; color: var(--color-text-secondary); margin-top: 6px;">${g.remarks}</div>
        <div style="font-size: 10px; color: var(--color-text-muted); margin-top: 4px;">Logged on ${g.date}</div>
      </div>
    `).join('')}
  `;

  // 3D Flip
  const flipContainer = document.getElementById('idCardFlipperContainer');
  if (flipContainer) {
    flipContainer.addEventListener('click', () => {
      flipContainer.classList.toggle('flipped');
      HapticFeedback.click();
    });
  }

  // Grievance Submit
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
        remarks: 'Acknowledged by Care Cell. Assigned to section officer.'
      };

      state.grievances.unshift(newTicket);
      HapticFeedback.success();
      showToast(`Grievance registered successfully! Ticket #${newTicket.id}`);
      form.reset();
      renderServicesScreen();
    });
  }

  attach3DTiltHandlers();
}

// Screen 5: Admin Hub (Notice Studio & Audit Trail)
function renderAdminScreen() {
  if (!checkPermission(PERMISSIONS.VIEW_ADMIN_DASHBOARD) && !checkPermission(PERMISSIONS.PUBLISH_STATUTORY_CIRCULARS)) {
    showToast('Administrator privileges required.', 'error');
    switchTab('home');
    return;
  }

  el.screenAdmin.innerHTML = `
    <!-- Approval Center Banner Link -->
    <div class="card tilt-card" style="border: 2px solid var(--color-primary); background: var(--color-surface-elevated);">
      <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
          <h3 style="font-family: var(--font-display); font-size: 14px; font-weight: 700;">Registration & Role Approvals Center</h3>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">
            ${state.accounts.filter(a => a.status === 'PENDING').length} Pending Review • ${state.accounts.filter(a => a.status === 'UNDER_REVIEW').length} In Progress
          </p>
        </div>
        <button class="btn btn-sm btn-primary" id="btnAdminOpenApprovals">Open Center →</button>
      </div>
    </div>

    <!-- Official Notice Publishing Studio -->
    <div class="card tilt-card">
      <div class="section-header-row" style="margin-top: 0;">
        <span class="section-title">Publish Gazetted Circular / Order</span>
        <span class="role-pill-chip" style="background: var(--color-primary-container); color: var(--color-primary);">Statutory Authority</span>
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

        <button type="submit" class="btn btn-primary btn-full">Publish Notice to Institutional Ledger</button>
      </form>
    </div>

    <!-- Immutable Audit Trail Ledger -->
    <div class="section-header-row">
      <span class="section-title">Institutional Audit Trail</span>
      <span style="font-size: 10px; font-weight: 700; color: var(--color-text-muted);">Immutable Records</span>
    </div>

    <div style="max-height: 250px; overflow-y: auto;">
      ${state.auditTrail.map(aud => `
        <div class="card" style="margin-bottom: var(--space-xs); padding: 10px; font-size: 11px;">
          <div style="display: flex; justify-content: space-between; align-items: center;">
            <strong style="color: var(--color-primary);">${aud.action}</strong>
            <span style="color: var(--color-text-muted); font-size: 10px;">${aud.timestamp}</span>
          </div>
          <div style="margin-top: 3px;"><strong>Actor:</strong> ${aud.actor}</div>
          <div><strong>Target:</strong> ${aud.targetUser}</div>
          <div style="color: var(--color-text-secondary); margin-top: 2px;">${aud.remarks}</div>
        </div>
      `).join('')}
    </div>
  `;

  document.getElementById('btnAdminOpenApprovals')?.addEventListener('click', () => switchTab('approvals'));

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
        issuedBy: state.currentUser.designation || 'Controller of Examinations',
        urgent: urg,
        summary: sum
      };

      state.circulars.unshift(newNotice);

      state.auditTrail.unshift({
        id: `aud_${Date.now()}`,
        timestamp: 'Just now',
        actor: `${state.currentUser.name} (${state.currentUser.activeRole})`,
        targetUser: 'CAMPUS-WIDE BROADCAST',
        action: 'CIRCULAR_PUBLISHED',
        previousStatus: 'DRAFT',
        newStatus: 'PUBLISHED',
        remarks: `Published statutory gazette "${title}"`
      });

      HapticFeedback.success();
      showToast(`Circular "${title}" published and broadcasted to campus!`);
      pubForm.reset();
      renderHomeScreen();
      renderAdminScreen();
    });
  }

  attach3DTiltHandlers();
}

// Screen 8: CoE Staff Examination Hub
function renderCoeScreen() {
  el.screenCoe.innerHTML = `
    <div class="card tilt-card" style="border-left: 4px solid var(--color-secondary);">
      <h3 style="font-family: var(--font-display); font-size: 15px; font-weight: 700;">Examination Branch Operations</h3>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">Controller of Examinations Tabulation & Hall Ticket Registry Hub.</p>
    </div>

    <div class="section-header-row">
      <span class="section-title">e-SANAD Hall Ticket Generation Queue</span>
      <button class="btn btn-sm btn-primary" id="btnIssueAllTickets">Issue Approved Cohort (420 Tickets)</button>
    </div>

    <div class="card tilt-card">
      <div style="font-size: 12px; line-height: 1.5;">
        <div><strong>Session:</strong> Nov / Dec 2026 End Semester Examinations (ESE)</div>
        <div><strong>Status:</strong> Tabulation Active • 4 Exam Halls Allocated</div>
        <div><strong>Security Protocol:</strong> Cryptographic SHA-256 Token QR Embedded</div>
      </div>
      <button class="btn btn-sm btn-outline" style="margin-top: 10px;" id="btnInspectCoETicket">Inspect Master e-SANAD Ticket</button>
    </div>
  `;

  document.getElementById('btnIssueAllTickets')?.addEventListener('click', () => {
    HapticFeedback.success();
    showToast('Batch e-SANAD Hall Tickets issued and synced with DigiLocker!');
  });

  document.getElementById('btnInspectCoETicket')?.addEventListener('click', openHallTicketModal);

  attach3DTiltHandlers();
}

// Screen 9: Research Scholar Hub
function renderScholarScreen() {
  el.screenScholar.innerHTML = `
    <div class="card tilt-card" style="border-left: 4px solid var(--color-tertiary);">
      <h3 style="font-family: var(--font-display); font-size: 15px; font-weight: 700;">Doctoral Research & Fellowship Suite</h3>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">Research Scholar: ${state.currentUser.name} (${state.currentUser.institutionalId})</p>
    </div>

    <div class="card tilt-card">
      <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700;">National Research Consortia Access</h4>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">Direct remote access to e-ShodhSindhu, IEEE Xplore, DELNET, and JSTOR.</p>
      <div style="display: flex; gap: 6px; margin-top: 8px;">
        <span class="role-pill-chip" style="background: var(--color-success-bg); color: var(--color-success);">e-ShodhSindhu: Active</span>
        <span class="role-pill-chip" style="background: var(--color-primary-container); color: var(--color-primary);">JRF Fellowship: Credited</span>
      </div>
    </div>
  `;

  attach3DTiltHandlers();
}

// Screen 10: Faculty Hub
function renderFacultyScreen() {
  el.screenFaculty.innerHTML = `
    <div class="card tilt-card" style="border-left: 4px solid var(--color-primary);">
      <h3 style="font-family: var(--font-display); font-size: 15px; font-weight: 700;">Faculty Academic Management</h3>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">Course lectures, CIA mark tabulation, and staff duty compensation.</p>
    </div>

    <div class="card tilt-card">
      <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
          <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700;">CS501: Advanced Cloud Computing</h4>
          <div style="font-size: 11px; color: var(--color-text-secondary);">MCA Semester IV • 38 Students Enrolled</div>
        </div>
        <button class="btn btn-sm btn-primary" id="btnTakeClassAtt">Take Biometrics</button>
      </div>
    </div>
  `;

  document.getElementById('btnTakeClassAtt')?.addEventListener('click', () => {
    HapticFeedback.success();
    showToast('Lecture attendance marked for CS501 (36 present, 2 absent).');
  });

  attach3DTiltHandlers();
}

// --- 14. Modals Management ---

// Modal: GRI-Sahayak AI
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

// Modal: Examination Hall Ticket
function openHallTicketModal() {
  HapticFeedback.click();
  const u = state.currentUser || state.accounts[1];
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
        <img src="/assets/${u.activeRole === 'STUDENT' ? 'student_avatar.jpg' : 'gri_official_logo.png'}" alt="${u.name}" style="width: 64px; height: 64px; border-radius: 6px; object-fit: cover; border: 1.5px solid #CBD5E1; flex-shrink: 0;">
        <div class="ht-student-grid" style="flex: 1; margin-bottom: 0; background: transparent; padding: 0;">
          <div><strong>Student Name:</strong> ${u.name}</div>
          <div><strong>Register / Roll No:</strong> ${u.institutionalId || '23MCA042'}</div>
          <div><strong>Degree / Programme:</strong> ${u.program || 'MCA'}</div>
          <div><strong>Semester:</strong> ${u.semester || 'Semester IV'}</div>
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

// Modal: Official Document Center
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
      <button class="btn btn-sm btn-outline btn-download-doc" data-id="${d.id}">Download</button>
    </div>
  `).join('');

  document.querySelectorAll('.btn-download-doc').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const id = e.currentTarget.getAttribute('data-id');
      showToast(`Downloaded verified document ${id}`);
    });
  });
}

// Modal: Authorized Multi-Role Switcher Sheet
function openRoleSwitcherModal() {
  const u = state.currentUser;
  if (!u || u.status !== 'APPROVED') {
    showToast('Role switching is only available for approved institutional accounts.', 'info');
    return;
  }

  // Per rule: NO fake role switching! Only show already-approved roles!
  if (u.approvedRoles.length <= 1) {
    showToast(`Your account has 1 authorized institutional role (${u.approvedRoles[0]}).`, 'info');
    return;
  }

  el.authorizedRolesList.innerHTML = `
    <div style="font-size: 12px; color: var(--color-text-secondary); margin-bottom: 12px;">
      User: <strong>${u.name}</strong> • Select an already-approved institutional identity:
    </div>

    ${u.approvedRoles.map(role => `
      <div class="auth-role-option-row ${u.activeRole === role ? 'active' : ''}" data-role="${role}">
        <div>
          <div style="font-family: var(--font-display); font-weight: 700; font-size: 14px;">${role}</div>
          <div style="font-size: 11px; color: var(--color-text-secondary);">
            ${role === 'FACULTY' ? 'Teaching & Class Roster' : 'Doctoral Research & Publications'}
          </div>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          ${u.activeRole === role ? '<span style="color: var(--color-primary); font-weight: 800;">✓ Active</span>' : '<span style="font-size: 11px; color: var(--color-text-muted);">Switch →</span>'}
        </div>
      </div>
    `).join('')}
  `;

  document.querySelectorAll('.auth-role-option-row').forEach(row => {
    row.addEventListener('click', (e) => {
      const r = e.currentTarget.getAttribute('data-role');
      if (r !== u.activeRole) {
        const prev = u.activeRole;
        u.activeRole = r;

        state.auditTrail.unshift({
          id: `aud_${Date.now()}`,
          timestamp: 'Just now',
          actor: `${u.name} (${prev})`,
          targetUser: u.name,
          action: 'ROLE_SWITCHED',
          previousStatus: prev,
          newStatus: r,
          remarks: `User switched between authorized approved roles`
        });

        HapticFeedback.success();
        showToast(`Switched active context to ${r}`);
        el.roleSwitcherModal.classList.remove('active');
        updateDynamicNavigation();
        switchTab('home');
      }
    });
  });

  el.roleSwitcherModal.classList.add('active');
}

// Modal: Notifications Drawer
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
    { title: 'Registration Status Notification', text: 'Institutional registry processed 14 applications today.', time: '20m ago', unread: true },
    { title: 'Campus Transit Route 1 Update', text: 'Bus TN-57-N-2418 is running on schedule via Chinnalapatti.', time: '25m ago', unread: true }
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

// Sync trigger
function triggerSync() {
  if (state.isSyncing) return;
  state.isSyncing = true;
  HapticFeedback.click();
  showToast('Connecting to Central Registry & Ktor ledger...');

  setTimeout(() => {
    state.isSyncing = false;
    HapticFeedback.success();
    showToast('Registry synchronized. All institutional records up to date.');
  }, 1200);
}

// --- 15. Event Listeners Initialization ---
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

  // Global Account selector (for instantaneous institutional testing)
  el.globalAccountSelect?.addEventListener('change', (e) => {
    const val = e.target.value;
    if (val === 'usr_public') {
      state.currentUser = null;
      updateDynamicNavigation();
      switchTab('home');
      showToast('Viewing portal as unauthenticated Public Visitor');
    } else {
      authenticateUser(val);
    }
  });

  // Top Bar Role Badge Click
  el.roleBadgeBtn?.addEventListener('click', () => {
    if (!state.currentUser || state.currentUser.status === 'PUBLIC') {
      openAuthModal();
    } else if (state.currentUser.status !== 'APPROVED') {
      switchTab('status');
    } else if (state.currentUser.approvedRoles.length > 1) {
      openRoleSwitcherModal();
    } else {
      showToast(`Account: ${state.currentUser.name} • Status: Approved ${state.currentUser.activeRole}`);
    }
  });

  // Open Register Trigger
  el.openRegisterBtn?.addEventListener('click', openRegisterModal);
  el.linkOpenRegister?.addEventListener('click', (e) => {
    e.preventDefault();
    closeAuthModal();
    openRegisterModal();
  });
  el.linkPublicVisitor?.addEventListener('click', (e) => {
    e.preventDefault();
    closeAuthModal();
    state.currentUser = null;
    updateDynamicNavigation();
    switchTab('home');
    showToast('Browsing as Public Visitor');
  });

  // Register Modal Steps
  el.btnNextToStep2?.addEventListener('click', () => {
    const name = document.getElementById('regName').value;
    const email = document.getElementById('regEmail').value;
    const pass = document.getElementById('regPassword').value;
    if (!name || !email || !pass) {
      showToast('Please fill all identity credentials.', 'error');
      return;
    }
    showRegisterStep(2);
  });

  el.btnBackToStep1?.addEventListener('click', () => showRegisterStep(1));

  document.querySelectorAll('input[name="requestedRole"]').forEach(radio => {
    radio.addEventListener('change', (e) => {
      renderDynamicRoleFields(e.target.value);
    });
  });

  el.btnNextToStep3?.addEventListener('click', () => {
    const selectedRadio = document.querySelector('input[name="requestedRole"]:checked');
    const role = selectedRadio ? selectedRadio.value : 'STUDENT';
    renderDynamicRoleFields(role);
    showRegisterStep(3);
  });

  el.btnBackToStep2?.addEventListener('click', () => showRegisterStep(2));

  // Registration Form Submission
  el.registrationWizardForm?.addEventListener('submit', (e) => {
    e.preventDefault();
    const name = document.getElementById('regName').value;
    const email = document.getElementById('regEmail').value;
    const mobile = document.getElementById('regMobile').value;
    const selectedRadio = document.querySelector('input[name="requestedRole"]:checked');
    const role = selectedRadio ? selectedRadio.value : 'STUDENT';
    const instId = document.getElementById('dynInstId')?.value || 'Pending';
    const dept = document.getElementById('dynDept')?.value || 'The Gandhigram Rural Institute';
    const prog = document.getElementById('dynProgram')?.value || 'Academic Programme';

    const appId = `GRI-2026-APP-${Math.floor(1000 + Math.random() * 9000)}`;

    const newAccount = {
      id: `usr_${Date.now()}`,
      name,
      email,
      mobile,
      institutionalId: instId,
      status: 'PENDING',
      requestedRole: role,
      approvedRoles: [],
      activeRole: 'GUEST',
      applicationId: appId,
      department: dept,
      program: prog,
      submittedAt: 'Just now',
      reviewedAt: null,
      reviewedBy: null,
      rejectionReason: null,
      infoRequested: null,
      infoProvided: null
    };

    state.accounts.push(newAccount);

    state.auditTrail.unshift({
      id: `aud_${Date.now()}`,
      timestamp: 'Just now',
      actor: `${name} (Applicant)`,
      targetUser: `${name} (${instId})`,
      action: 'REGISTRATION_SUBMITTED',
      previousStatus: 'NONE',
      newStatus: 'PENDING',
      remarks: `Submitted application for ${role}. App ID: ${appId}`
    });

    HapticFeedback.success();
    closeRegisterModal();
    showToast(`Application ${appId} submitted for Dean verification!`);

    // Log in as pending applicant immediately to display status
    authenticateUser(newAccount.id);
  });

  // Modal Closers
  el.closeAuthBtn?.addEventListener('click', closeAuthModal);
  el.closeRegisterBtn?.addEventListener('click', closeRegisterModal);
  el.closeAdminReviewBtn?.addEventListener('click', () => el.adminReviewModal.classList.remove('active'));
  el.closeRoleSwitcherBtn?.addEventListener('click', () => el.roleSwitcherModal.classList.remove('active'));

  // Sahayak Modal
  el.openSahayakBtn?.addEventListener('click', openSahayakModal);
  el.closeSahayakBtn?.addEventListener('click', closeSahayakModal);
  el.sahayakForm?.addEventListener('submit', (e) => {
    e.preventDefault();
    handleSahayakSubmit(el.sahayakInput.value);
  });
  document.querySelectorAll('#sahayakChips .chip-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const q = btn.getAttribute('data-query');
      handleSahayakSubmit(q);
    });
  });

  // Hall Ticket Modal
  el.closeHallTicketBtn?.addEventListener('click', closeHallTicketModal);
  el.doneTicketBtn?.addEventListener('click', closeHallTicketModal);
  el.printTicketBtn?.addEventListener('click', () => window.print());

  // Document Center
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

  // Notifications
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
      if (e.target === modal) modal.classList.remove('active');
    });
  });

  // Dynamic Island
  document.getElementById('dynamicIsland')?.addEventListener('click', () => {
    switchTab('campus');
    showToast('Navigating to Live Transit Radar');
  });

  // Initial Boot
  updateDynamicNavigation();
  switchTab('home');
}

// Run on DOM Ready
document.addEventListener('DOMContentLoaded', initEvents);
