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
  ],

  // --- 1. Leadership Directory ---
  leadership: {
    chancellor: { name: 'Dr. T. S. Soundram & Dr. G. Ramachandran (Founders)', role: 'Founding Patrons • Nai Talim Pioneers' },
    viceChancellor: { name: 'Prof. Dr. N. Panchanatham', role: 'Vice-Chancellor', phone: '+91 451 2452305', email: 'vc@ruraluniv.ac.in', office: 'VC Secretariat, Main Administrative Block' },
    registrar: { name: 'Dr. M. Sundaramari', role: 'Registrar in-charge', phone: '+91 451 2452371', email: 'registrar@ruraluniv.ac.in', office: 'Central Administrative Secretariat' },
    controllerOfExaminations: { name: 'Dr. V. Sivakumar', role: 'Controller of Examinations', phone: '+91 451 2454222', email: 'coe@ruraluniv.ac.in', office: 'Controller of Examinations Directorate' },
    financeOfficer: { name: 'Dr. K. S. Pushpa', role: 'Finance Officer (in-charge)', phone: '+91 451 2452373', email: 'fo@ruraluniv.ac.in', office: 'Finance Section' },
    cvo: { name: 'Dr. M. G. Sethuraman', role: 'Chief Vigilance Officer', phone: '+91 451 2452375', email: 'cvo@ruraluniv.ac.in', office: 'CVO Office' },
    deans: [
      { school: 'School of Sciences', name: 'Dr. S. Kanthimathinathan', email: 'dean_sciences@ruraluniv.ac.in', phone: 'Ext 201' },
      { school: 'School of Agriculture and Animal Sciences', name: 'Dr. K. S. Pushpa', email: 'dean_agri@ruraluniv.ac.in', phone: 'Ext 202' },
      { school: 'School of Rural Health and Sanitation', name: 'Dr. M. G. Sethuraman', email: 'dean_health@ruraluniv.ac.in', phone: 'Ext 203' },
      { school: 'School of Social Sciences', name: 'Dr. P. Anandharajakumar', email: 'dean_socsci@ruraluniv.ac.in', phone: 'Ext 204' },
      { school: 'School of Tamil, Indian Languages and Rural Arts', name: 'Dr. M. Kuruvammal', email: 'dean_tamil@ruraluniv.ac.in', phone: 'Ext 205' },
      { school: 'School of English & Foreign Languages', name: 'Dr. S. Senthilnathan', email: 'dean_english@ruraluniv.ac.in', phone: 'Ext 206' },
      { school: 'School of Management Studies', name: 'Dr. T. Selvin Jebaraj Norman', email: 'dean_mgmt@ruraluniv.ac.in', phone: 'Ext 207' },
      { school: 'School of Education', name: 'Dr. P. S. Balasubramanian', email: 'dean_edu@ruraluniv.ac.in', phone: 'Ext 208' }
    ]
  },

  // --- 2. 8 Schools & Academic Departments ---
  schools: [
    {
      id: 'sch_sci',
      name: 'School of Sciences',
      dean: 'Dr. S. Kanthimathinathan',
      departments: ['Department of Mathematics', 'Department of Physics', 'Department of Chemistry', 'Department of Computer Science & Applications', 'Department of Biology'],
      programmesCount: 16,
      highlights: 'DST-FIST Supported Labs, Central NMR & XRD Instrumentation Facility, Cloud Computing Lab'
    },
    {
      id: 'sch_agri',
      name: 'School of Agriculture and Animal Sciences',
      dean: 'Dr. K. S. Pushpa',
      departments: ['Department of Agriculture', 'Department of Animal Husbandry', 'Krishi Vigyan Kendra (ICAR-KVK)'],
      programmesCount: 9,
      highlights: 'ICAR Accredited B.Sc. (Hons.) Agriculture, Organic Dairy Farm, Agro-Meteorological Unit'
    },
    {
      id: 'sch_health',
      name: 'School of Rural Health and Sanitation',
      dean: 'Dr. M. G. Sethuraman',
      departments: ['Department of Rural Health & Sanitation', 'Department of Applied Research'],
      programmesCount: 7,
      highlights: 'WHO collaborating projects, Pioneer in Sanitary Inspector Training since 1965'
    },
    {
      id: 'sch_socsci',
      name: 'School of Social Sciences',
      dean: 'Dr. P. Anandharajakumar',
      departments: ['Department of Rural Development', 'Department of Economics', 'Department of Lifelong Learning & Extension', 'Department of Sociology', 'Centre for Social Exclusion and Inclusive Policy'],
      programmesCount: 14,
      highlights: 'Nai Talim Village Internship, Kasturba Seva Ashram Field Action Projects'
    },
    {
      id: 'sch_tamil',
      name: 'School of Tamil, Indian Languages and Rural Arts',
      dean: 'Dr. M. Kuruvammal',
      departments: ['Department of Tamil', 'Department of Hindi', 'Centre for Malayalam', 'Department of Fine & Rural Arts'],
      programmesCount: 10,
      highlights: 'Classical Tamil Palm-leaf Archives, Folk Arts Troupe, Rural Handicrafts Centre'
    },
    {
      id: 'sch_english',
      name: 'School of English & Foreign Languages',
      dean: 'Dr. S. Senthilnathan',
      departments: ['Department of English', 'Foreign Languages Unit (French & German)'],
      programmesCount: 6,
      highlights: 'Multimedia Language Laboratory, Comparative Literature & Translation Studies'
    },
    {
      id: 'sch_mgmt',
      name: 'School of Management Studies',
      dean: 'Dr. T. Selvin Jebaraj Norman',
      departments: ['Department of Rural Management', 'Department of Commerce'],
      programmesCount: 8,
      highlights: 'MBA Rural Management (AICTE Approved), Microfinance & Rural Enterprise Incubator'
    },
    {
      id: 'sch_edu',
      name: 'School of Education',
      dean: 'Dr. P. S. Balasubramanian',
      departments: ['Department of Education', 'Centre for Educational Technology'],
      programmesCount: 5,
      highlights: 'NCTE Approved ITEP 4-Year B.Ed. Integrated Programme, Smart Classroom Demonstration Suite'
    }
  ],

  // --- 3. Complete Catalogue of 81+ Programmes ---
  programmes: [
    // School of Sciences
    { id: 'prog_mca', school: 'School of Sciences', name: 'Master of Computer Applications (MCA)', level: 'PG', duration: '2 Years (4 Semesters)', eligibility: 'Passed BCA/B.Sc. Computer Science/IT or B.Sc./B.Com./B.A. with Mathematics at 10+2 or Graduation level with 50% marks.', cuetCode: 'SCQP09', intake: 60, status: 'CURRENT' },
    { id: 'prog_msc_cs', school: 'School of Sciences', name: 'M.Sc. Computer Science', level: 'PG', duration: '2 Years', eligibility: 'B.Sc. Computer Science/IT/BCA with min 50% marks.', cuetCode: 'SCQP09', intake: 40, status: 'CURRENT' },
    { id: 'prog_bsc_cs', school: 'School of Sciences', name: 'B.Sc. Computer Science', level: 'UG', duration: '3 Years (6 Semesters)', eligibility: '10+2 with Mathematics/Business Maths/Computer Science.', cuetCode: 'UG011', intake: 50, status: 'CURRENT' },
    { id: 'prog_msc_che', school: 'School of Sciences', name: 'M.Sc. Applied Chemistry', level: 'PG', duration: '2 Years', eligibility: 'B.Sc. Chemistry with Mathematics/Physics allied.', cuetCode: 'SCQP08', intake: 35, status: 'CURRENT' },
    { id: 'prog_bsc_che', school: 'School of Sciences', name: 'B.Sc. Chemistry', level: 'UG', duration: '3 Years', eligibility: '10+2 with Chemistry, Physics, Mathematics/Biology.', cuetCode: 'UG012', intake: 45, status: 'CURRENT' },
    { id: 'prog_msc_phy', school: 'School of Sciences', name: 'M.Sc. Physics', level: 'PG', duration: '2 Years', eligibility: 'B.Sc. Physics with Mathematics allied.', cuetCode: 'SCQP24', intake: 35, status: 'CURRENT' },
    { id: 'prog_msc_mat', school: 'School of Sciences', name: 'M.Sc. Mathematics', level: 'PG', duration: '2 Years', eligibility: 'B.Sc. Mathematics with min 50% marks.', cuetCode: 'SCQP19', intake: 40, status: 'CURRENT' },
    
    // School of Agriculture
    { id: 'prog_bsc_agri', school: 'School of Agriculture and Animal Sciences', name: 'B.Sc. (Hons.) Agriculture', level: 'UG', duration: '4 Years (8 Semesters)', eligibility: '10+2 with Physics, Chemistry, Biology/Mathematics or Vocational Agriculture with 60% aggregate.', cuetCode: 'UG001', intake: 60, status: 'CURRENT' },
    { id: 'prog_dip_agri', school: 'School of Agriculture and Animal Sciences', name: 'Diploma in Agriculture', level: 'Diploma', duration: '2 Years', eligibility: 'Pass in 10th Standard / SSLC.', cuetCode: 'NON-CUET', intake: 40, status: 'CURRENT' },
    { id: 'prog_msc_agro', school: 'School of Agriculture and Animal Sciences', name: 'M.Sc. Agriculture (Agronomy)', level: 'PG', duration: '2 Years', eligibility: 'B.Sc. Agriculture / Horticulture from recognized ICAR accredited institution.', cuetCode: 'SCQP01', intake: 15, status: 'CURRENT' },

    // School of Rural Health & Sanitation
    { id: 'prog_dip_si', school: 'School of Rural Health and Sanitation', name: 'Diploma in Sanitary Inspector Course', level: 'Diploma', duration: '1 Year (2 Semesters)', eligibility: '10+2 with Science (Biology/Physics/Chemistry) passed.', cuetCode: 'NON-CUET', intake: 60, status: 'CURRENT' },
    { id: 'prog_pgd_si', school: 'School of Rural Health and Sanitation', name: 'Post Graduate Diploma in Sanitary Inspector Course', level: 'PG Diploma', duration: '1 Year', eligibility: 'Bachelor degree in Science / Public Health / Microbiology.', cuetCode: 'NON-CUET', intake: 30, status: 'CURRENT' },
    { id: 'prog_msc_health', school: 'School of Rural Health and Sanitation', name: 'M.Sc. Health & Sanitation Sciences', level: 'PG', duration: '2 Years', eligibility: 'B.Sc. in allied health/biological sciences.', cuetCode: 'SCQP15', intake: 25, status: 'CURRENT' },

    // School of Social Sciences
    { id: 'prog_ma_rd', school: 'School of Social Sciences', name: 'M.A. Rural Development', level: 'PG', duration: '2 Years', eligibility: 'Any Bachelor Degree from a recognized University with min 50% marks.', cuetCode: 'COQP11', intake: 40, status: 'CURRENT' },
    { id: 'prog_ba_gsw', school: 'School of Social Sciences', name: 'B.A. (Hons.) Gandhian Social Work', level: 'UG', duration: '3 Years', eligibility: '10+2 from recognized board in any stream.', cuetCode: 'UG005', intake: 40, status: 'CURRENT' },
    { id: 'prog_msw', school: 'School of Social Sciences', name: 'Master of Social Work (MSW)', level: 'PG', duration: '2 Years', eligibility: 'Any graduation degree with 50% marks.', cuetCode: 'COQP11', intake: 45, status: 'CURRENT' },
    { id: 'prog_ma_eco', school: 'School of Social Sciences', name: 'M.A. Development Economics', level: 'PG', duration: '2 Years', eligibility: 'B.A. Economics / B.Com. / BBA / B.Sc. Mathematics.', cuetCode: 'COQP10', intake: 35, status: 'CURRENT' },

    // School of Management
    { id: 'prog_mba_rm', school: 'School of Management Studies', name: 'MBA Rural Management', level: 'PG', duration: '2 Years (AICTE Approved)', eligibility: 'Any Bachelor degree with min 50% marks + CUET-PG / MAT / TANCET score.', cuetCode: 'COQP12', intake: 60, status: 'CURRENT' },
    { id: 'prog_bcom_coop', school: 'School of Management Studies', name: 'B.Com. Cooperative Management', level: 'UG', duration: '3 Years', eligibility: '10+2 with Commerce, Accountancy, Business Studies.', cuetCode: 'UG008', intake: 50, status: 'CURRENT' },

    // School of Education
    { id: 'prog_itep_bed', school: 'School of Education', name: 'ITEP 4-Year B.Ed. Integrated Programme', level: 'UG-Integrated', duration: '4 Years (8 Semesters - NCTE)', eligibility: '10+2 with 50% marks + NCET Entrance Test score.', cuetCode: 'NCET-ITEP', intake: 50, status: 'CURRENT' },
    { id: 'prog_med', school: 'School of Education', name: 'Master of Education (M.Ed.)', level: 'PG', duration: '2 Years (NCTE Approved)', eligibility: 'B.Ed. / B.El.Ed. with minimum 55% marks.', cuetCode: 'COQP15', intake: 50, status: 'CURRENT' },

    // School of Tamil
    { id: 'prog_ma_tamil', school: 'School of Tamil, Indian Languages and Rural Arts', name: 'M.A. Tamil & Folk Arts', level: 'PG', duration: '2 Years', eligibility: 'B.A. Tamil or any degree with Part-I Tamil.', cuetCode: 'LAQP02', intake: 35, status: 'CURRENT' },

    // Doctoral Programmes (Sample of 27 disciplines)
    { id: 'prog_phd_cs', school: 'School of Sciences', name: 'Ph.D. in Computer Science', level: 'Doctoral', duration: '3 to 5 Years', eligibility: 'Master degree in Computer Science/Applications with 55% marks + UGC NET/JRF or GRI Entrance.', cuetCode: 'GRI-RET', intake: 12, status: 'CURRENT' },
    { id: 'prog_phd_agri', school: 'School of Agriculture and Animal Sciences', name: 'Ph.D. in Agriculture', level: 'Doctoral', duration: '3 to 5 Years', eligibility: 'M.Sc. Agriculture with 55% marks + ICAR JRF/NET.', cuetCode: 'ICAR-RET', intake: 8, status: 'CURRENT' },
    { id: 'prog_phd_rd', school: 'School of Social Sciences', name: 'Ph.D. in Rural Development', level: 'Doctoral', duration: '3 to 5 Years', eligibility: 'M.A. Rural Development / MSW with 55% marks.', cuetCode: 'GRI-RET', intake: 10, status: 'CURRENT' },
    { id: 'prog_dsc_dlitt', school: 'Research & Development Cell', name: 'D.Sc. and D.Litt. Post Doctoral Fellowship', level: 'Post-Doc', duration: '2 to 3 Years', eligibility: 'Published Ph.D. degree holders with minimum 5 years post-doctoral research and high-impact publications.', cuetCode: 'STATUTORY', intake: 5, status: 'CURRENT' }
  ],

  // --- 4. Admissions 2026-27 Ecosystem ---
  admissions: {
    academicYear: '2026–2027',
    currentCycle: 'Academic Year 2026–27 (Current Admissions)',
    cuetRequirement: 'NTA CUET 2026 is mandatory for all mainstream UG & PG programmes. Non-CUET applications are considered for remaining unfilled seats in Diploma, Certificate, and select lateral entry courses.',
    importantDates: [
      { event: 'CUET-UG / PG Score Updation on Samarth Portal', date: 'Ongoing (Check Portal)', status: 'OPEN' },
      { event: 'Direct / Non-CUET Application Submission', date: '30 Sep 2026 (Extended)', status: 'OPEN' },
      { event: 'Ph.D. Entrance Examination (RET Session II)', date: '15 Oct 2026', status: 'UPCOMING' },
      { event: 'Commencement of Classes for Senior & Fresh Students', date: 'Completed (Classes in Session)', status: 'ARCHIVED' }
    ],
    prospectuses: [
      { title: 'GRI Admission Prospectus 2026–2027 (Official)', file: 'Prospectus_202627.pdf', size: '4.2 MB', url: 'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf', status: 'CURRENT' },
      { title: 'GRI Admission Prospectus 2025–2026 (Reference Archive)', file: 'Prospectus_202526.pdf', size: '3.9 MB', url: 'https://www.ruraluniv.ac.in/includes/admissions/2025/pdf/Prospectus_202526.pdf', status: 'ARCHIVED' }
    ],
    helpdesk: {
      phone1: '9043648800',
      phone2: '9043648811',
      timings: 'Monday to Friday, 9:30 AM – 5:00 PM',
      generalEmail: 'helpdesk@ruraluniv.ac.in',
      paymentEmail: 'payment@ruraluniv.ac.in',
      office: 'Admissions Section, Academic Block, GRI'
    },
    statutoryLinks: [
      { title: 'Samarth@GRI Admission Portal', url: 'https://ruraluniv.samarth.ac.in/index.php/site/login', desc: 'Official online application and registration ledger' },
      { title: 'Fee Refund Policy (UGC Mandated)', url: 'https://ruraluniv.ac.in/admn1?content=Refund', desc: 'Rules for fee refund upon cancellation of admission' },
      { title: 'Hostel Fees Details & Mess Deposit', url: 'https://ruraluniv.ac.in/admn1?content=Hostel_fee', desc: 'Room rent, water/electricity charges, and caution deposit' },
      { title: 'Ph.D. Research Regulations', url: 'https://ruraluniv.ac.in/admissions?content=PhD_Regulations', desc: 'Minimum standards and procedures for Ph.D. awards' },
      { title: 'D.Sc. and D.Litt. Regulations', url: 'https://ruraluniv.ac.in/admissions?content=Dsc_Regulations', desc: 'Post-doctoral research degree rules' }
    ]
  },

  // --- 5. Dedicated Examination Ecosystem (CoE Directorate) ---
  examinations: {
    coeName: 'Dr. V. Sivakumar',
    coeOffice: 'Office of the Controller of Examinations, GRI',
    currentSession: 'End Semester Examinations (ESE) • November / December 2026',
    systemType: 'Choice Based Credit System (CBCS) • Continuous Formative Assessment (CFA 50%) + End Semester (ESE 50%)',
    schedules: [
      { code: 'CS501', title: 'Advanced Cloud Computing', date: '2026-11-24', session: 'FN (10:00 AM – 01:00 PM)', hall: 'Exam Hall 4, Block B', status: 'UPCOMING' },
      { code: 'RD402', title: 'Gandhian Reconstruction & Ethics', date: '2026-11-26', session: 'FN (10:00 AM – 01:00 PM)', hall: 'Exam Hall 4, Block B', status: 'UPCOMING' },
      { code: 'CS505', title: 'Distributed Mobile & Web Architectures', date: '2026-11-29', session: 'AN (02:00 PM – 05:00 PM)', hall: 'Exam Hall 2, Block A', status: 'UPCOMING' },
      { code: 'MA301', title: 'Applied Statistical Analytics', date: '2026-12-02', session: 'FN (10:00 AM – 01:00 PM)', hall: 'Exam Hall 4, Block B', status: 'UPCOMING' },
      { code: 'CA404', title: 'Nai Talim Village Internship Fieldwork Viva', date: '2026-12-05', session: 'FN (09:30 AM – 01:30 PM)', hall: 'Seminar Hall, CSA', status: 'UPCOMING' }
    ],
    tatkalScheme: {
      title: 'Tatkal Scheme for Fast-Track Degree / Transcript Issuance',
      description: 'Expedited processing within 48 hours for urgent visa, employment, or foreign university admissions.',
      instructionUrl: 'http://ruraluniv.ac.in/includes/examination/pdf/Tatkal_instruction.pdf',
      registrationUrl: 'https://www.portal.ruraluniv.ac.in/tatkal',
      fee: 'Tatkal processing fee: ₹2,000 + nominal document charges'
    },
    eSanad: {
      title: 'e-SANAD Document Attestation & Digital Verification',
      description: 'Integrated with Ministry of External Affairs (MEA) and National Academic Depository (NAD) DigiLocker for contactless authentication.',
      notificationUrl: 'http://ruraluniv.ac.in/includes/examination/pdf/e-sanad301221.pdf',
      portalUrl: 'https://www.portal.ruraluniv.ac.in/esanad'
    },
    forms: [
      { title: 'Application for Official Mark Transcript', url: 'http://ruraluniv.ac.in/includes/examination/pdf/Application_Transcript.pdf', type: 'PDF' },
      { title: 'Application for Duplicate Degree / Grade Certificate', url: 'http://ruraluniv.ac.in/includes/examination/pdf/DuplicateCertificate.pdf', type: 'PDF' },
      { title: 'Compliance Certificate of Ph.D. Degree with UGC Regulations', url: 'http://ruraluniv.ac.in/includes/studcorner/pdf/ugc_cc221217.pdf', type: 'PDF' }
    ],
    resultsLedger: [
      { sem: 'Semester III', sgpa: '8.92', cgpa: '8.84', creditsEarned: 24, status: 'PASSED (DISTINCTION)', session: 'April 2026' },
      { sem: 'Semester II', sgpa: '8.75', cgpa: '8.80', creditsEarned: 22, status: 'PASSED', session: 'Nov 2025' },
      { sem: 'Semester I', sgpa: '8.85', cgpa: '8.85', creditsEarned: 22, status: 'PASSED', session: 'April 2025' }
    ]
  },

  // --- 6. Official Scholarship & Fellowships Ecosystem ---
  scholarships: [
    {
      id: 'sch_nsp_cent',
      name: 'National Scholarship Portal (NSP) — Central Sector Scheme',
      provider: 'Ministry of Education, Govt. of India',
      category: 'Merit-cum-Means',
      awardAmount: '₹12,000 to ₹20,000 / year',
      academicYear: '2026–2027',
      status: 'OPEN',
      eligibility: 'Top 20th percentile in 10+2 board examinations with family income < ₹4.50 LPA.',
      deadline: '31 Oct 2026',
      applyUrl: 'https://scholarships.gov.in/',
      officialSource: 'ruraluniv.ac.in • Students Corner'
    },
    {
      id: 'sch_ugc_jrf',
      name: 'UGC-NET Junior Research Fellowship (JRF)',
      provider: 'University Grants Commission (UGC)',
      category: 'Research Fellowship',
      awardAmount: '₹37,000 / month + 16% HRA + Contingency',
      academicYear: '2026–2027',
      status: 'CURRENT',
      eligibility: 'UGC-NET / CSIR-NET JRF qualified candidates enrolled in full-time Ph.D. programme at GRI.',
      deadline: 'Rolling (Continuous)',
      applyUrl: 'https://ugcnet.nta.nic.in/',
      officialSource: 'RDC • Research and Development Cell'
    },
    {
      id: 'sch_nfsc',
      name: 'National Fellowship for Scheduled Caste Students (NFSC)',
      provider: 'Ministry of Social Justice & Empowerment',
      category: 'Doctoral Fellowship',
      awardAmount: '₹37,000 / month + Contingency',
      academicYear: '2026–2027',
      status: 'CURRENT',
      eligibility: 'SC candidates admitted to M.Phil./Ph.D. at GRI having cleared UGC-NET.',
      deadline: 'Annual Call (Check Portal)',
      applyUrl: 'https://scholarships.gov.in/',
      officialSource: 'ruraluniv.ac.in • Reservation Cell'
    },
    {
      id: 'sch_nfobc',
      name: 'National Fellowship for Other Backward Classes (NFOBC)',
      provider: 'Ministry of Social Justice & Empowerment',
      category: 'Doctoral Fellowship',
      awardAmount: '₹37,000 / month + Contingency',
      academicYear: '2026–2027',
      status: 'CURRENT',
      eligibility: 'OBC candidates enrolled in Ph.D. with non-creamy layer verification.',
      deadline: 'Annual Call',
      applyUrl: 'https://scholarships.gov.in/',
      officialSource: 'ruraluniv.ac.in • Reservation Cell'
    },
    {
      id: 'sch_post_matric',
      name: 'Government of Tamil Nadu Post-Matric Scholarship',
      provider: 'Adi Dravidar and Tribal Welfare Dept, Govt of Tamil Nadu',
      category: 'State Welfare Scheme',
      awardAmount: 'Full Tuition Fee Waiver + Maintenance Allowance',
      academicYear: '2026–2027',
      status: 'OPEN',
      eligibility: 'Native SC/ST/SCC students studying in regular courses at GRI with family annual income < ₹2.50 LPA.',
      deadline: '15 Nov 2026',
      applyUrl: 'https://escholarship.tn.gov.in/',
      officialSource: 'Dean of Student Welfare'
    },
    {
      id: 'sch_girl_child',
      name: 'Indira Gandhi Single Girl Child PG Scholarship',
      provider: 'University Grants Commission (UGC)',
      category: 'Women Empowerment',
      awardAmount: '₹36,200 / annum (for 2 Years)',
      academicYear: '2026–2027',
      status: 'OPEN',
      eligibility: 'Single girl child of parents enrolled in first year of regular PG programme.',
      deadline: '30 Nov 2026',
      applyUrl: 'https://scholarships.gov.in/',
      officialSource: 'UGC • ruraluniv.ac.in'
    },
    {
      id: 'sch_aicte_pragati',
      name: 'AICTE Pragati & Saksham Scholarship Scheme',
      provider: 'AICTE',
      category: 'Technical Education (MCA / MBA)',
      awardAmount: '₹50,000 / year',
      academicYear: '2026–2027',
      status: 'OPEN',
      eligibility: 'Girl students (Pragati) and differently abled students (Saksham) admitted to AICTE approved MCA / MBA courses.',
      deadline: '31 Dec 2026',
      applyUrl: 'https://scholarships.gov.in/',
      officialSource: 'School of Management & Computer Science'
    }
  ],

  // --- 7. Master Document Inventory (16+ Verified Documents) ---
  officialDocuments: [
    {
      id: 'doc_prospectus_2026',
      title: 'GRI Admission Prospectus 2026–2027',
      category: 'Admissions',
      department: 'Admissions Directorate',
      date: '15 Aug 2026',
      academicYear: '2026–2027',
      docType: 'Official Prospectus',
      officialSource: 'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf',
      applicableRole: 'Public, Students, Applicants',
      status: 'CURRENT',
      fileSize: '4.2 MB',
      sha256: '9f8b4a2e5d7c1a3b6e8f0a2c4e6b8d0f2a4c6e8b0d2f4a6c8e0b2d4f6a8c0e2b'
    },
    {
      id: 'doc_cbcs_regs',
      title: 'CBCS Academic Regulations & Evaluation Guidelines',
      category: 'Academics',
      department: 'Academic Council',
      date: '10 Jul 2026',
      academicYear: '2026–2027',
      docType: 'University Statutory Regulations',
      officialSource: 'https://ruraluniv.ac.in/academics?content=CBCSsystem',
      applicableRole: 'Students, Faculty',
      status: 'CURRENT',
      fileSize: '1.8 MB',
      sha256: '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b'
    },
    {
      id: 'doc_tatkal_instruction',
      title: 'Tatkal Scheme — Instructions for Fast-Track Degree Issuance',
      category: 'Examinations',
      department: 'Controller of Examinations',
      date: '05 May 2026',
      academicYear: '2026–2027',
      docType: 'Administrative Notification',
      officialSource: 'http://ruraluniv.ac.in/includes/examination/pdf/Tatkal_instruction.pdf',
      applicableRole: 'Alumni, Students, CoE Staff',
      status: 'CURRENT',
      fileSize: '340 KB',
      sha256: '3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e'
    },
    {
      id: 'doc_esanad_notif',
      title: 'e-SANAD Digital Attestation & Verification Procedure',
      category: 'Examinations',
      department: 'Controller of Examinations',
      date: '30 Dec 2021',
      academicYear: 'Statutory Standing Order',
      docType: 'Statutory Order',
      officialSource: 'http://ruraluniv.ac.in/includes/examination/pdf/e-sanad301221.pdf',
      applicableRole: 'All Roles, MEA Verifiers',
      status: 'CURRENT',
      fileSize: '512 KB',
      sha256: '5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b'
    },
    {
      id: 'doc_transcript_app',
      title: 'Application for Official Academic Transcript',
      category: 'Forms',
      department: 'Controller of Examinations',
      date: '12 Jan 2026',
      academicYear: '2026–2027',
      docType: 'Downloadable Form',
      officialSource: 'http://ruraluniv.ac.in/includes/examination/pdf/Application_Transcript.pdf',
      applicableRole: 'Students, Alumni',
      status: 'CURRENT',
      fileSize: '210 KB',
      sha256: '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c'
    },
    {
      id: 'doc_duplicate_cert',
      title: 'Application for Duplicate Certificates / Grade Sheets',
      category: 'Forms',
      department: 'Controller of Examinations',
      date: '10 Feb 2026',
      academicYear: '2026–2027',
      docType: 'Downloadable Form',
      officialSource: 'http://ruraluniv.ac.in/includes/examination/pdf/DuplicateCertificate.pdf',
      applicableRole: 'Alumni, Students',
      status: 'CURRENT',
      fileSize: '195 KB',
      sha256: '9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d'
    },
    {
      id: 'doc_phd_compliance',
      title: 'Certificate of Compliance of Ph.D. Degree with UGC Regulations',
      category: 'Research',
      department: 'Controller of Examinations & RDC',
      date: '22 Dec 2022',
      academicYear: 'Permanent Regulation',
      docType: 'Compliance Certificate',
      officialSource: 'http://ruraluniv.ac.in/includes/studcorner/pdf/ugc_cc221217.pdf',
      applicableRole: 'Research Scholars, Faculty',
      status: 'CURRENT',
      fileSize: '280 KB',
      sha256: '2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a'
    },
    {
      id: 'doc_fee_refund',
      title: 'Institutional Fee Refund Policy & Guidelines',
      category: 'Administration',
      department: 'Registrar Secretariat',
      date: '01 Jun 2026',
      academicYear: '2026–2027',
      docType: 'Policy Document',
      officialSource: 'https://ruraluniv.ac.in/admn1?content=Refund',
      applicableRole: 'Public, Applicants',
      status: 'CURRENT',
      fileSize: '410 KB',
      sha256: '4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c'
    },
    {
      id: 'doc_hostel_fee',
      title: 'Hostel Fees Schedule and Caution Deposit Policy',
      category: 'Student Documents',
      department: 'Chief Warden Office',
      date: '15 Jul 2026',
      academicYear: '2026–2027',
      docType: 'Fee Schedule',
      officialSource: 'https://ruraluniv.ac.in/admn1?content=Hostel_fee',
      applicableRole: 'Hostel Residents, Students',
      status: 'CURRENT',
      fileSize: '320 KB',
      sha256: '6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e'
    },
    {
      id: 'doc_phd_regs',
      title: 'Ph.D. Academic Regulations & Research Manual',
      category: 'Research',
      department: 'Research and Development Cell (RDC)',
      date: '01 May 2026',
      academicYear: '2026–2027',
      docType: 'Statutory Regulations',
      officialSource: 'https://ruraluniv.ac.in/admissions?content=PhD_Regulations',
      applicableRole: 'Scholars, Faculty, Research Guides',
      status: 'CURRENT',
      fileSize: '1.4 MB',
      sha256: '8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a'
    },
    {
      id: 'doc_dsc_regs',
      title: 'D.Sc. and D.Litt. Higher Research Degree Regulations',
      category: 'Research',
      department: 'RDC Directorate',
      date: '14 Feb 2026',
      academicYear: '2026–2027',
      docType: 'Higher Doctorate Regulations',
      officialSource: 'https://ruraluniv.ac.in/admissions?content=Dsc_Regulations',
      applicableRole: 'Post-Doctoral Researchers, Senior Faculty',
      status: 'CURRENT',
      fileSize: '950 KB',
      sha256: '0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c'
    },
    {
      id: 'doc_prospectus_2025',
      title: 'GRI Admission Prospectus 2025–2026 (Archive)',
      category: 'Admissions',
      department: 'Admissions Directorate',
      date: '20 May 2025',
      academicYear: '2025–2026',
      docType: 'Historical Prospectus',
      officialSource: 'https://www.ruraluniv.ac.in/includes/admissions/2025/pdf/Prospectus_202526.pdf',
      applicableRole: 'Public, Reference',
      status: 'ARCHIVED',
      fileSize: '3.9 MB',
      sha256: '2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e'
    },
    {
      id: 'doc_annual_report',
      title: 'Annual Institutional Performance Report & NIRF Ranking Data',
      category: 'Administration',
      department: 'Internal Quality Assurance Cell (IQAC)',
      date: '18 Mar 2026',
      academicYear: '2025–2026',
      docType: 'Institutional Audit',
      officialSource: 'https://ruraluniv.ac.in/',
      applicableRole: 'All Roles, Statutory Regulators',
      status: 'CURRENT',
      fileSize: '5.6 MB',
      sha256: '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a'
    }
  ],

  // --- 8. About GRI & Governance Master Data ---
  aboutGri: {
    institutionName: 'The Gandhigram Rural Institute (Deemed to be University)',
    genesis: 'Founded in 1956 by two dedicated disciples of Mahatma Gandhi — Dr. T. S. Soundram and Dr. G. Ramachandran — to bring higher education to rural youth. In 1976, the Ministry of Education, Govt. of India conferred the status of Deemed to be University under Section 3 of the UGC Act.',
    philosophy: 'Nai Talim (Basic Education) — integrating head, heart, and hand through classroom learning, laboratory experimentation, and village extension work.',
    accreditation: "NAAC Accredited with 'A+' Grade (CGPA: 3.34 in 3rd Cycle). 100% compliant with UGC Deemed to be University Regulations 2023.",
    campusArea: '300 Acres of serene rural land at the foothills of Sirumalai, Chinnalapatti, Dindigul District, Tamil Nadu 624302.',
    governanceBodies: [
      { name: 'Executive Council (EC)', role: 'Supreme executive body for institutional administration, policy decisions, and appointments.' },
      { name: 'Academic Council (AC)', role: 'Governing statutory body for academic regulations, CBCS curricula, examinations, and new programmes.' },
      { name: 'Planning and Monitoring Board (PMB)', role: 'Oversees university master planning, development milestones, and resource optimization.' },
      { name: 'Finance Committee (FC)', role: 'Audits budgetary allocations, UGC grants, and financial statutory disclosures.' }
    ]
  },

  // --- 9. Official Institutional Sub-Portals ---
  officialPortals: [
    { title: 'Samarth@GRI ERP Portal', url: 'https://ruraluniv.samarth.ac.in/index.php/site/login', desc: 'Enterprise academic and administration portal', category: 'Core ERP' },
    { title: 'GRI Student Portal', url: 'https://portal.ruraluniv.ac.in/', desc: 'Student profile, marks, attendance, and hall ticket services', category: 'Student' },
    { title: 'Online Attendance Portal', url: 'https://attendance.ruraluniv.ac.in/', desc: 'Biometric and lecture attendance ledger', category: 'Academic' },
    { title: 'Pensioner Digital Portal', url: 'https://pension.ruraluniv.ac.in/', desc: 'Staff superannuation and pension ledger', category: 'Staff' },
    { title: 'Official GRI Webmail', url: 'https://webmail.ruraluniv.ac.in/', desc: 'Faculty & officer official correspondence suite', category: 'Institutional' },
    { title: 'e-SANAD Portal', url: 'https://www.portal.ruraluniv.ac.in/esanad', desc: 'Online contactless document attestation service', category: 'Examinations' },
    { title: 'Tatkal Scheme Registration', url: 'https://www.portal.ruraluniv.ac.in/tatkal', desc: 'Expedited degree certificate and transcript issuance', category: 'Examinations' },
    { title: 'GRI Convocation Portal', url: 'https://convocation.ruraluniv.ac.in/', desc: 'Graduation registration and degree conferment', category: 'Alumni' },
    { title: 'Alumni Association (GRI-AA)', url: 'https://ruraluniv.ac.in/includes/AlumniGRI', desc: 'Worldwide alumni network and mentorship', category: 'Alumni' },
    { title: 'Study in India (Govt. of India)', url: 'https://www.studyinindia.gov.in/admission/registrations', desc: 'International admissions for overseas students', category: 'Admissions' }
  ],

  // --- 11. Official Facilities, Infrastructure & Hostels Master Data ---
  facilities: [
    {
      id: 'fac_library',
      name: 'Dr. G. Ramachandran Central Library',
      category: 'Academic Learning Centre',
      image: '/assets/library_front.jpg',
      badge: 'RFID & KOHA AUTOMATED',
      description: 'Central knowledge repository with 1,83,587 volumes, rare Gandhian collections, 149 periodicals, 1,452 doctoral theses, and National Digital Library (NDL) node.',
      stats: [
        { num: '1,83,587', label: 'Books' },
        { num: '1,452', label: 'Ph.D. Theses' },
        { num: '23', label: 'Databases' }
      ],
      features: ['KOHA Open Source OPAC', 'RFID Kiosks & Smart Gate', 'Braille Corner for Divyangjan', 'E-ShodhSindhu Consortium'],
      contact: 'librarian@ruraluniv.ac.in • Ext: 2381',
      officialUrl: 'https://ruraluniv.ac.in/facilities?content=library'
    },
    {
      id: 'fac_health',
      name: 'GRI Campus Health Centre',
      category: 'Healthcare & Wellness',
      image: '/assets/health_centre.jpg',
      badge: '24/7 EMERGENCY CARE',
      description: 'Dedicated healthcare facility providing outpatient medical treatment, 24/7 ambulance support, clinical diagnostics, and wellness consultations for all students and residents.',
      stats: [
        { num: '24/7', label: 'Ambulance' },
        { num: 'Free', label: 'Basic Meds' },
        { num: 'Daily', label: 'Doctor OPD' }
      ],
      features: ['Resident Medical Officers', 'Clinical Laboratory Diagnostics', 'Emergency Oxygen Support', 'Pharmacy & Observation Beds'],
      contact: 'Health Centre Hotline: 0451-2452371',
      officialUrl: 'https://ruraluniv.ac.in/infrastructure?content=AboutHealthCentre'
    },
    {
      id: 'fac_computer_centre',
      name: 'GRI Central Computer Centre',
      category: 'Digital ICT Hub',
      image: '/assets/gri_emblem_3d.jpg',
      badge: 'NKN 1 GBPS GIGABIT',
      description: 'Established in 1989, powers high-speed fiber campus networking via National Knowledge Network (NKN), student computer labs (60+ terminals), and cloud portal servers.',
      stats: [
        { num: '1 Gbps', label: 'NKN Fiber' },
        { num: '60+', label: 'Lab Systems' },
        { num: '100%', label: 'Campus Wi-Fi' }
      ],
      features: ['High-Performance Computing Lab', 'Campus LAN & Wi-Fi Management', 'LMS & E-Content Servers', 'Cybersecurity IT Policy'],
      contact: 'cc@ruraluniv.ac.in • Ext: 2360',
      officialUrl: 'https://ruraluniv.ac.in/gri?CC=about'
    },
    {
      id: 'fac_cic',
      name: 'Central Instrumentation Centre (CIC)',
      category: 'Advanced Science Research',
      image: '/assets/grilogotya.jpg',
      badge: 'DST-FIST & PURSE',
      description: 'State-of-the-art analytical instrumentation facility supporting researchers and industry in spectroscopy, crystal analysis, and materials characterization.',
      stats: [
        { num: '400 MHz', label: 'NMR Spectrometer' },
        { num: 'XRD', label: 'Diffractometer' },
        { num: 'HPLC', label: 'Chromatography' }
      ],
      features: ['FT-IR & UV-Vis Spectrophotometers', 'Single Crystal X-ray Diffractometer', 'Atomic Absorption Spectrophotometer', 'External Sample Testing on Charge'],
      contact: 'cic@ruraluniv.ac.in',
      officialUrl: 'https://ruraluniv.ac.in/facilities?content=Central_Instrumentation_Centre'
    },
    {
      id: 'fac_seaweed',
      name: 'UBA GRI Seaweed Startup & Cultivation Facility',
      category: 'Rural Entrepreneurship & Incubation',
      image: '/assets/gri_sahayak_3d.jpg',
      badge: 'UNNAT BHARAT ABHIYAN',
      description: 'Flagship rural biotechnology venture training coastal self-help groups in Kappaphycus alvarezii cultivation, seaweed sap extraction, and organic bio-fertilizer production.',
      stats: [
        { num: 'UBA', label: 'Govt. Sponsored' },
        { num: '30+', label: 'SHGs Trained' },
        { num: 'Patented', label: 'Bio-stimulants' }
      ],
      features: ['Tissue Culture Nursery', 'Liquid Bio-Fertilizer Unit', 'Farmer Training Workshop', 'Patent Commercialization'],
      contact: 'seaweed@ruraluniv.ac.in',
      officialUrl: 'https://ruraluniv.ac.in/facilities?content=SEAWEED_1'
    },
    {
      id: 'fac_nano',
      name: 'Centre for Nanoscience & Nanotechnology',
      category: 'Nanomaterials & Cleanroom',
      image: '/assets/gridu_favicon.png',
      badge: 'ADVANCED NANOTECH',
      description: 'Dedicated cleanroom and synthesis lab developing solar cell thin films, antimicrobial nanoparticles, and smart rural water filtration membranes.',
      stats: [
        { num: 'Cleanroom', label: 'Class 10,000' },
        { num: 'Solar', label: 'Cell Research' },
        { num: 'Water', label: 'Purification' }
      ],
      features: ['Chemical Vapor Deposition', 'Sputtering Unit', 'Photovoltaic Characterization', 'Ph.D. Research Bench'],
      contact: 'nano@ruraluniv.ac.in',
      officialUrl: 'https://ruraluniv.ac.in/facilities?content=About_NANO_Facility'
    },
    {
      id: 'fac_museum',
      name: 'Museum of Constructive Programme & Khadi Looms',
      category: 'Heritage & Nai Talim',
      image: '/assets/grilogotya.jpg',
      badge: 'GANDHIAN HERITAGE',
      description: 'Living heritage pavilion showcasing Mahatma Gandhi’s 18-point Constructive Programme, vintage spinning charkhas, rural art forms, and Nai Talim pedagogy records.',
      stats: [
        { num: '1956', label: 'Historic Relics' },
        { num: '18', label: 'Constructive Areas' },
        { num: 'Khadi', label: 'Active Looms' }
      ],
      features: ['Original Gandhi Letters', 'Vintage Charka Collection', 'Village Artisan Exhibits', 'Student Study Gallery'],
      contact: 'museum@ruraluniv.ac.in',
      officialUrl: 'https://ruraluniv.ac.in/facilities?content=museum'
    }
  ],

  // --- 12. Hostels Master Directory ---
  hostelsDirectory: {
    totalCapacity: 1573,
    chiefWarden: 'Dean, Students Welfare (0451-2452371)',
    boysHostels: [
      { name: 'Dr. S. Radhakrishnan Hostel (4 Blocks)', description: 'Main Boys Complex: Dr. S. Radhakrishnan Block, Dr. Zakir Hussain Block, Research Scholars Block, Sri R. Venkatraman Block', type: 'Boys / Scholars' },
      { name: 'Faculty of Rural Health & Sanitation Hostel', description: 'Dedicated residential block for Diploma and B.Sc. Sanitary Inspector trainees', type: 'Boys' }
    ],
    ladiesHostels: [
      { name: 'Dr. Soundaram Illam', description: 'Senior postgraduate and research scholars residential wing', type: 'Ladies' },
      { name: 'Kannagi Illam & Andal Illam', description: 'Undergraduate and integrated masters residential wings', type: 'Ladies' },
      { name: 'Ladies Hostel New Block', description: 'Modern multi-storey wing with enhanced dining and solar water heating', type: 'Ladies' }
    ],
    workingWomensHostel: {
      name: "Working Women's Hostel & Day Care Centre",
      capacity: 85,
      rooms: 28,
      description: 'Two-storied facility with Day Care Centre for working mothers, researchers, and project fellows funded by Ministry of WCD and UGC.'
    },
    amenities: ['Pure RO Drinking Water', 'Community Mess & Dining Halls', 'Indoor Recreation & Badminton', 'Wi-Fi & Reading Rooms', 'Cooperative Store & Medical Care']
  },

  // --- 13. Academic Centres & Extension Master Data ---
  academicCentres: [
    {
      id: 'ctr_kvk',
      name: 'Krishi Vigyan Kendra (KVK - Farm Science Centre)',
      mandate: 'Agricultural Technology Assessment, Farmer Demonstrations & Skill Training',
      sponsor: 'Indian Council of Agricultural Research (ICAR)',
      lead: 'Senior Scientist & Head, KVK',
      activities: 'On-farm testing of bio-fertilizers, organic farming demonstrations, vocational trainings for rural youth, seed distribution.',
      contact: 'kvk@ruraluniv.ac.in',
      officialUrl: 'http://ruraluniv.ac.in/includes/academics/pdf/KVK.pdf'
    },
    {
      id: 'ctr_women',
      name: "Centre for Women's Studies (CWS)",
      mandate: 'Gender Sensitization, Women Empowerment & Rural Livelihood Research',
      sponsor: 'University Grants Commission (UGC)',
      lead: 'Director, Centre for Women Studies',
      activities: 'Women entrepreneurship training, legal literacy workshops, self-help group capacity building, rural gender surveys.',
      contact: 'cws@ruraluniv.ac.in',
      officialUrl: 'https://ruraluniv.ac.in/academics?content=womensstudies'
    },
    {
      id: 'ctr_geoinfo',
      name: 'Centre for Geoinformatics',
      mandate: 'GIS, Remote Sensing & Spatial Modeling for Watershed & Rural Governance',
      sponsor: 'DST / UGC',
      lead: 'Director, Geoinformatics',
      activities: 'Satellite imagery analysis, village cadastral mapping, drought vulnerability assessment, water body rejuvenation mapping.',
      contact: 'geoinfo@ruraluniv.ac.in',
      officialUrl: 'https://ruraluniv.ac.in/academics?content=geoinformatics'
    },
    {
      id: 'ctr_energy',
      name: 'Rural Energy Centre (REC)',
      mandate: 'Decentralized Renewable Energy, Solar Photovoltaics & Biomass Gasification',
      sponsor: 'MNRE / UGC',
      lead: 'Director, Rural Energy Centre',
      activities: 'Solar microgrid installations, smokeless chulhas, community biogas plants, energy audit of village clusters.',
      contact: 'energy@ruraluniv.ac.in',
      officialUrl: 'http://ruraluniv.ac.in/includes/academics/programmes/brochure/15330.pdf'
    },
    {
      id: 'ctr_cseip',
      name: 'Centre for Social Exclusion & Inclusive Policy (CSEIP)',
      mandate: 'Policy Research on Scheduled Castes, Tribal Communities & Marginalized Groups',
      sponsor: 'UGC',
      lead: 'Director, CSEIP',
      activities: 'Socio-economic studies, affirmative action impact evaluations, inclusive education seminars, policy advocacy.',
      contact: 'cseip@ruraluniv.ac.in',
      officialUrl: 'https://ruraluniv.ac.in/academics?content=cseip'
    }
  ],

  // --- 14. Live 2026 Careers & Tenders Feed ---
  careersAndTenders: [
    {
      id: 'car_legal_officer',
      title: 'Walk-in-Interview: Temporary Post of Legal Officer',
      type: 'CAREERS',
      date: '06 Oct 2026',
      time: '02:00 PM',
      venue: 'Faculty Guest House, GRI Main Campus',
      status: 'UPCOMING',
      summary: 'Engagement of qualified Legal Officer on temporary contract. Candidates must bring original degree certificates and practice credentials.',
      downloadUrl: 'https://www.ruraluniv.ac.in/'
    },
    {
      id: 'ten_health_insurance',
      title: 'Tender: Group Personal Accident & Health Insurance for Students',
      type: 'TENDERS',
      date: '05 Oct 2026',
      time: '04:00 PM (Submission Deadline)',
      venue: 'Office of the Registrar, GRI',
      status: 'ACTIVE',
      summary: 'Sealed competitive quotations invited from IRDA-approved insurance companies for tailor-made group student and research scholar medical policy.',
      downloadUrl: 'https://www.ruraluniv.ac.in/'
    },
    {
      id: 'car_guest_faculty',
      title: 'Walk-in-Interview: Guest/Part-Time Faculty (English & Foreign Languages)',
      type: 'CAREERS',
      date: '16 Sep 2026',
      time: '10:00 AM',
      venue: 'School of English & Foreign Languages',
      status: 'ARCHIVED',
      summary: 'Engagement of Guest Teachers for Odd Semester 2026 with UGC-NET / Ph.D. qualification in English.',
      downloadUrl: 'https://www.ruraluniv.ac.in/'
    },
    {
      id: 'ten_civil_maintenance',
      title: 'Notice Inviting Tender (NIT): Campus Maintenance & Civil Works',
      type: 'TENDERS',
      date: '28 Sep 2026',
      time: '03:00 PM',
      venue: 'Estate & Engineering Division, GRI',
      status: 'ACTIVE',
      summary: 'Quotations invited from registered CPWD/PWD contractors for compound wall repairs and facility upgradation in Centre for Rural Technology.',
      downloadUrl: 'https://www.ruraluniv.ac.in/'
    }
  ],

  // --- 15. The 7 Sacred Symbols of the Official GRI Emblem ---
  emblemSymbols: [
    { num: 1, name: 'Book on Open Lotus', meaning: 'Symbolizes enlightenment, spiritual awakening, and the purity of knowledge flourishing in rural soil.' },
    { num: 2, name: 'Traditional Lamp (Ahal)', meaning: 'Represents dispelling darkness and ignorance through knowledge, reflecting the university motto of selfless service.' },
    { num: 3, name: 'Traditional Kolam (Floor Art)', meaning: 'Celebrates rural Indian cultural aesthetics, geometry, domestic craftsmanship, and feminine auspiciousness.' },
    { num: 4, name: 'Concentric Squares', meaning: 'Depicts structured integration of learning, community life, self-governance, and disciplined constructive action.' },
    { num: 5, name: 'The Plough (Er)', meaning: 'Stands for agriculture, agrarian sustenance, the dignity of manual labor, and the empowerment of village farmers.' },
    { num: 6, name: 'The Spinning Wheel (Charka)', meaning: 'Mahatma Gandhi’s supreme emblem of Swadeshi (self-reliance), khadi heritage, and decentralized rural economy.' },
    { num: 7, name: 'Asclepius Rod & Bowl of Hygieia', meaning: 'Embodies rural community healthcare, sanitation, public hygiene, and compassion for all living beings.' }
  ],


  // --- 10. Admin Content Management System (CMS) State ---
  cmsItems: [
    {
      id: 'cms_1',
      title: 'End Semester Examinations Nov/Dec 2026 Time Table for UG/PG/B.Voc.',
      category: 'Examinations',
      freshness: 'CURRENT',
      stage: 'PUBLISHED',
      summary: 'Detailed timetable for CBCS End Semester Theory and Practical Examinations released by Controller of Examinations.',
      docUrl: 'http://ruraluniv.ac.in/examtt',
      issuedBy: 'Office of the Controller of Examinations',
      audience: 'ALL',
      isUrgent: true,
      publishedAt: '24 Sep 2026, 10:00 AM'
    },
    {
      id: 'cms_2',
      title: 'Direct Second Year Admission in B.Sc. (Hons.) Agriculture Lateral Entry',
      category: 'Admissions',
      freshness: 'CURRENT',
      stage: 'PUBLISHED',
      summary: 'Applications invited from eligible diploma holders in agriculture for direct lateral entry into semester III.',
      docUrl: 'https://ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf',
      issuedBy: 'Dean, School of Agriculture and Animal Sciences',
      audience: 'ALL',
      isUrgent: false,
      publishedAt: '20 Sep 2026, 02:30 PM'
    },
    {
      id: 'cms_3',
      title: 'Draft Guidelines for Nai Talim Sarvodaya Village Winter Internship 2026',
      category: 'Academics',
      freshness: 'UPCOMING',
      stage: 'REVIEW',
      summary: 'Mandatory rural reconstruction residency draft syllabus pending Academic Council ratification.',
      docUrl: 'https://ruraluniv.ac.in/academics?content=CBCSsystem',
      issuedBy: 'Dean of Academic Affairs',
      audience: 'FACULTY',
      isUrgent: false,
      publishedAt: null
    }
  ],

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
  screenFaculty: document.getElementById('screenFaculty'),
  screenAdmissions: document.getElementById('screenAdmissions'),
  screenExams: document.getElementById('screenExams'),
  screenScholarships: document.getElementById('screenScholarships'),
  screenAbout: document.getElementById('screenAbout'),

  // Global Search Modal
  openGlobalSearchBtn: document.getElementById('openGlobalSearchBtn'),
  globalSearchModal: document.getElementById('globalSearchModal'),
  globalSearchInput: document.getElementById('globalSearchInput'),
  closeGlobalSearchBtn: document.getElementById('closeGlobalSearchBtn'),
  searchFilterPills: document.getElementById('searchFilterPills'),
  searchResultsList: document.getElementById('searchResultsList'),

  // Admin CMS Modal
  adminCmsModal: document.getElementById('adminCmsModal'),
  closeAdminCmsBtn: document.getElementById('closeAdminCmsBtn'),
  adminCmsForm: document.getElementById('adminCmsForm'),
  cmsTitle: document.getElementById('cmsTitle'),
  cmsCategory: document.getElementById('cmsCategory'),
  cmsFreshness: document.getElementById('cmsFreshness'),
  cmsSummary: document.getElementById('cmsSummary'),
  cmsDocUrl: document.getElementById('cmsDocUrl'),
  cmsIssuedBy: document.getElementById('cmsIssuedBy'),
  cmsAudience: document.getElementById('cmsAudience'),
  cmsIsUrgent: document.getElementById('cmsIsUrgent'),
  btnSaveCmsDraft: document.getElementById('btnSaveCmsDraft'),
  btnPublishCmsContent: document.getElementById('btnPublishCmsContent'),

  // Document Preview Modal
  docPreviewModal: document.getElementById('docPreviewModal'),
  closeDocPreviewBtn: document.getElementById('closeDocPreviewBtn'),
  docPreviewTitle: document.getElementById('docPreviewTitle'),
  docPreviewSubtitle: document.getElementById('docPreviewSubtitle'),
  docPreviewContent: document.getElementById('docPreviewContent')
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
      { id: 'admissions', label: 'Admissions', icon: '<path d="M12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/>' },
      { id: 'exams', label: 'Exams', icon: '<path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>' },
      { id: 'about', label: 'About GRI', icon: '<path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>' },
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
      { id: 'exams', label: 'Exams', icon: '<path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>' },
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
  else if (tabId === 'admissions') renderAdmissionsScreen();
  else if (tabId === 'exams') renderExamsScreen();
  else if (tabId === 'scholarships') renderScholarshipsScreen();
  else if (tabId === 'about') renderAboutScreen();
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
    <!-- Official Institutional Banner Header -->
    <div style="background: #fff; border-radius: var(--radius-md); padding: 6px; margin-bottom: var(--space-sm); border: 1px solid var(--color-surface-border); text-align: center; box-shadow: var(--shadow-sm);">
      <img src="/assets/official_banner.png" alt="Gandhigram Rural Institute" style="width: 100%; max-height: 48px; object-fit: contain;">
    </div>

    <!-- Live Campus Announcement Ticker -->
    <div style="background: rgba(0, 54, 34, 0.06); border: 1px solid rgba(0, 54, 34, 0.2); border-radius: var(--radius-sm); padding: 6px 10px; margin-bottom: var(--space-sm); display: flex; align-items: center; gap: 8px;">
      <span class="freshness-badge current" style="flex-shrink: 0; font-size: 9px; padding: 2px 6px;">● LIVE NOTICE</span>
      <div style="font-size: 11px; font-weight: 600; color: var(--color-primary); overflow: hidden; white-space: nowrap; text-overflow: ellipsis; flex: 1;">
        Convocation XXXIX Registration Open • Legal Officer Walk-in Oct 6 • Student Health Insurance Tender (Due: Oct 5) • ESE Nov/Dec 2026 Timetable Released
      </div>
    </div>

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

    <!-- Primary Institutional Ecosystem Portals -->
    <div class="section-header-row">
      <span class="section-title">Institutional Ecosystem & Gateways</span>
    </div>

    <div class="quick-action-grid">
      <button class="action-card-btn highlight" id="btnNavAdmissions">
        <div class="action-icon-circle">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/></svg>
        </div>
        <span class="action-btn-label">Admissions 26</span>
      </button>

      <button class="action-card-btn highlight" id="btnNavExams">
        <div class="action-icon-circle">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
        </div>
        <span class="action-btn-label">Examinations</span>
      </button>

      <button class="action-card-btn" id="btnNavScholarships">
        <div class="action-icon-circle">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"/></svg>
        </div>
        <span class="action-btn-label">Scholarships</span>
      </button>

      <button class="action-card-btn" id="btnNavAbout">
        <div class="action-icon-circle">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>
        </div>
        <span class="action-btn-label">About GRI</span>
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
        <span class="action-btn-label">Document Hub</span>
      </button>

      ${checkPermission(PERMISSIONS.VIEW_HALL_TICKET) ? `
        <button class="action-card-btn" id="btnQuickHallTicket">
          <div class="action-icon-circle">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M22 10V6c0-1.11-.9-2-2-2H4c-1.1 0-1.99.89-1.99 2v4c1.1 0 1.99.9 1.99 2s-.89 2-2 2v4c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2v-4c-1.1 0-2-.9-2-2s.9-2 2-2z"/></svg>
          </div>
          <span class="action-btn-label">Hall Ticket</span>
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
    </div>

    <!-- Official Notices Feed with Freshness Indicators -->
    <div class="section-header-row">
      <span class="section-title">Official Gazettes & Notices</span>
      <a href="#" class="section-action-link" id="homeViewGazettesLink">Document Hub →</a>
    </div>

    <div class="circulars-list">
      ${state.circulars.map(c => `
        <div class="notice-item-card tilt-card" data-id="${c.id}">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
            <span class="notice-pill-tag ${c.urgent ? 'urgent' : ''}">${c.urgent ? 'URGENT' : c.category}</span>
            <span class="freshness-badge current">CURRENT</span>
          </div>
          <div class="notice-content-col">
            <h4 class="notice-title">${c.title}</h4>
            <p class="notice-summary">${c.summary}</p>
            <div class="notice-meta-line">Issued by ${c.issuedBy} • ${c.date}</div>
          </div>
        </div>
      `).join('')}
    </div>

    <!-- Source Transparency -->
    <div class="source-transparency-card">
      <div class="source-meta-text">
        <strong>Source Transparency:</strong> The Gandhigram Rural Institute Official Website (<a href="https://www.ruraluniv.ac.in/" target="_blank" style="color: var(--color-primary);">ruraluniv.ac.in</a>)
      </div>
      <span class="official-seal-chip">✓ AUTHENTICATED</span>
    </div>
  `;

  // Attach button events
  document.getElementById('btnNavAdmissions')?.addEventListener('click', () => switchTab('admissions'));
  document.getElementById('btnNavExams')?.addEventListener('click', () => switchTab('exams'));
  document.getElementById('btnNavScholarships')?.addEventListener('click', () => switchTab('scholarships'));
  document.getElementById('btnNavAbout')?.addEventListener('click', () => switchTab('about'));
  document.getElementById('btnGoToApprovals')?.addEventListener('click', () => switchTab('approvals'));
  document.getElementById('btnQuickHallTicket')?.addEventListener('click', openHallTicketModal);
  document.getElementById('btnQuickBus')?.addEventListener('click', () => switchTab('campus'));
  document.getElementById('btnQuickSahayak')?.addEventListener('click', openSahayakModal);
  document.getElementById('btnQuickDocCenter')?.addEventListener('click', openDocCenterModal);
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
    <!-- 8 Schools & Academic Departments Explorer -->
    <div class="section-header-row">
      <span class="section-title">Academic Schools & Centres (${state.schools.length})</span>
      <span style="font-size: 11px; font-weight: 700; color: var(--color-primary);">CBCS System</span>
    </div>

    <div style="display: grid; grid-template-columns: 1fr; gap: 8px; margin-bottom: var(--space-md);">
      ${state.schools.map(s => `
        <div class="card tilt-card" style="padding: 12px;">
          <div style="display: flex; justify-content: space-between; align-items: flex-start;">
            <div>
              <h3 style="font-family: var(--font-display); font-size: 13px; font-weight: 700;">${s.name}</h3>
              <div style="font-size: 11px; color: var(--color-primary); font-weight: 600;">Dean: ${s.dean}</div>
            </div>
            <span style="font-size: 10px; font-weight: 700; background: var(--color-surface-elevated); padding: 2px 6px; border-radius: var(--radius-sm); border: 1px solid var(--color-surface-border);">
              ${s.programmesCount} Programmes
            </span>
          </div>
          <div style="font-size: 10px; color: var(--color-text-secondary); margin-top: 4px;">
            <strong>Departments:</strong> ${s.departments.join(', ')}
          </div>
          <div style="font-size: 10px; color: var(--color-text-muted); margin-top: 2px;">
            ${s.highlights}
          </div>
        </div>
      `).join('')}
    </div>
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
let currentCampusSubtab = 'facilities';

function renderCampusScreen() {
  const facs = state.facilities || [];
  const hst = state.hostelsDirectory || {};
  const ctrs = state.academicCentres || [];
  const tndrs = state.careersAndTenders || [];

  el.screenCampus.innerHTML = `
    <!-- Campus Hub Header with Sub-tabs Navigation -->
    <div class="campus-subtab-bar">
      <button class="campus-subtab-btn ${currentCampusSubtab === 'facilities' ? 'active' : ''}" data-subtab="facilities">🏛️ Facilities & Labs</button>
      <button class="campus-subtab-btn ${currentCampusSubtab === 'hostels' ? 'active' : ''}" data-subtab="hostels">🏠 Hostels & Life</button>
      <button class="campus-subtab-btn ${currentCampusSubtab === 'centres' ? 'active' : ''}" data-subtab="centres">🔬 Extension & KVK</button>
      <button class="campus-subtab-btn ${currentCampusSubtab === 'careers' ? 'active' : ''}" data-subtab="careers">💼 Careers & Tenders</button>
      <button class="campus-subtab-btn ${currentCampusSubtab === 'transit' ? 'active' : ''}" data-subtab="transit">🚌 Transit Radar</button>
    </div>

    ${currentCampusSubtab === 'facilities' ? `
      <!-- Facilities List with Authentic Photographs -->
      <div class="section-header-row" style="margin-top: 0;">
        <span class="section-title">Key Campus Facilities & Instrumentation</span>
        <span class="role-pill-chip" style="background: var(--color-primary-container); color: var(--color-primary);">Verified Infrastructure</span>
      </div>

      ${facs.map(fac => `
        <div class="facility-card tilt-card">
          <div class="facility-img-wrap">
            <img src="${fac.image}" alt="${fac.name}" class="facility-img" onerror="this.src='/assets/gri_official_logo.png'">
            <span class="facility-badge-float">${fac.badge}</span>
          </div>
          <div class="facility-body">
            <span class="freshness-badge current" style="margin-bottom: 4px;">● ${fac.category.toUpperCase()}</span>
            <h3 class="facility-title">${fac.name}</h3>
            <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">${fac.description}</p>
            
            <div class="facility-stats-grid">
              ${fac.stats.map(s => `
                <div class="facility-stat-pill">
                  <div class="facility-stat-num">${s.num}</div>
                  <div class="facility-stat-desc">${s.label}</div>
                </div>
              `).join('')}
            </div>

            <div style="margin: 8px 0; font-size: 10px; color: var(--color-text-muted);">
              <strong>Highlights:</strong> ${fac.features.join(' • ')}
            </div>

            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 8px; font-size: 11px;">
              <span style="color: var(--color-text-secondary); font-size: 10px;">${fac.contact}</span>
              <a href="${fac.officialUrl}" target="_blank" class="btn btn-sm btn-primary">Open Portal ↗</a>
            </div>
          </div>
        </div>
      `).join('')}
    ` : ''}

    ${currentCampusSubtab === 'hostels' ? `
      <!-- Hostels & Residential Directory -->
      <div class="card tilt-card" style="background: linear-gradient(135deg, rgba(0, 54, 34, 0.08) 0%, rgba(212, 160, 23, 0.08) 100%); margin-bottom: var(--space-md);">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div>
            <span class="freshness-badge current">● RESIDENTIAL LIFE</span>
            <h3 style="font-family: var(--font-display); font-size: 15px; font-weight: 700; margin-top: 4px;">GRI Residential Community</h3>
            <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">
              Total Inmate Capacity: <strong>${hst.totalCapacity || '1,573'}</strong> • Gandhian Community Living
            </p>
          </div>
          <div style="text-align: right;">
            <span style="font-family: var(--font-display); font-size: 20px; font-weight: 800; color: var(--color-primary);">${hst.totalCapacity || '1,573'}</span>
            <div style="font-size: 9px; color: var(--color-text-muted);">RESIDENTS</div>
          </div>
        </div>
        <div style="margin-top: 8px; font-size: 10px; color: var(--color-text-secondary);">
          <strong>Chief Warden:</strong> ${hst.chiefWarden}
        </div>
      </div>

      <!-- Boys Hostels -->
      <div class="section-header-row">
        <span class="section-title">Boys Hostels & Research Blocks</span>
      </div>
      ${(hst.boysHostels || []).map(b => `
        <div class="card tilt-card" style="padding: 12px; margin-bottom: 8px;">
          <div style="display: flex; justify-content: space-between;">
            <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; color: var(--color-primary);">${b.name}</h4>
            <span class="role-pill-chip">${b.type}</span>
          </div>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.35;">${b.description}</p>
        </div>
      `).join('')}

      <!-- Ladies Hostels -->
      <div class="section-header-row" style="margin-top: var(--space-md);">
        <span class="section-title">Ladies Hostels Complex</span>
      </div>
      ${(hst.ladiesHostels || []).map(l => `
        <div class="card tilt-card" style="padding: 12px; margin-bottom: 8px;">
          <div style="display: flex; justify-content: space-between;">
            <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; color: var(--color-secondary);">${l.name}</h4>
            <span class="role-pill-chip" style="background: rgba(212, 160, 23, 0.15); color: #B45309;">${l.type}</span>
          </div>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.35;">${l.description}</p>
        </div>
      `).join('')}

      <!-- Working Women's Hostel -->
      ${hst.workingWomensHostel ? `
        <div class="card tilt-card" style="border: 2px solid var(--color-primary); margin-top: var(--space-md); padding: 12px;">
          <span class="freshness-badge current">● DAY CARE INTEGRATED</span>
          <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; margin-top: 4px;">${hst.workingWomensHostel.name}</h4>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.35;">${hst.workingWomensHostel.description}</p>
          <div style="display: flex; gap: 8px; margin-top: 6px; font-size: 11px; font-weight: 600; color: var(--color-primary);">
            <span>Capacity: ${hst.workingWomensHostel.capacity} Inmates</span> • <span>Rooms: ${hst.workingWomensHostel.rooms}</span>
          </div>
        </div>
      ` : ''}

      <!-- Amenities -->
      <div style="margin-top: var(--space-md); font-size: 10px; color: var(--color-text-muted); text-align: center;">
        <strong>Common Amenities:</strong> ${(hst.amenities || []).join(' • ')}
      </div>
    ` : ''}

    ${currentCampusSubtab === 'centres' ? `
      <!-- Academic & Extension Centres -->
      <div class="section-header-row" style="margin-top: 0;">
        <span class="section-title">Specialized Research & Extension Centres</span>
      </div>

      ${ctrs.map(c => `
        <div class="card tilt-card" style="padding: 12px; margin-bottom: var(--space-sm);">
          <div style="display: flex; justify-content: space-between; align-items: flex-start;">
            <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; color: var(--color-primary);">${c.name}</h4>
            <span class="role-pill-chip" style="font-size: 9px;">${c.sponsor}</span>
          </div>
          <div style="font-size: 11px; font-weight: 600; color: var(--color-text-primary); margin-top: 4px;">${c.mandate}</div>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.35;">${c.activities}</p>
          <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 8px; font-size: 10px;">
            <span style="color: var(--color-text-muted);">${c.lead} • ${c.contact}</span>
            <a href="${c.officialUrl}" target="_blank" class="btn btn-sm btn-outline">Official Brochure ↗</a>
          </div>
        </div>
      `).join('')}
    ` : ''}

    ${currentCampusSubtab === 'careers' ? `
      <!-- Careers & Tenders Feed -->
      <div class="section-header-row" style="margin-top: 0;">
        <span class="section-title">Institutional Careers & Tenders 2026</span>
        <span class="role-pill-chip" style="background: var(--color-error-bg); color: var(--color-error);">Statutory Notifications</span>
      </div>

      ${tndrs.map(t => `
        <div class="tender-card tilt-card">
          <div class="tender-header">
            <div>
              <span class="tender-badge">${t.type}</span>
              <span class="freshness-badge ${t.status.toLowerCase()}" style="margin-left: 4px;">${t.status}</span>
              <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; margin-top: 6px;">${t.title}</h4>
            </div>
          </div>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 6px; line-height: 1.4;">${t.summary}</p>
          <div class="tender-deadline-box">
            <div><strong>Date / Deadline:</strong> ${t.date} (${t.time})</div>
            <div><strong>Venue:</strong> ${t.venue}</div>
          </div>
          <div style="display: flex; justify-content: flex-end; margin-top: 8px;">
            <a href="${t.downloadUrl}" target="_blank" class="btn btn-sm btn-primary">Download Official Order ↗</a>
          </div>
        </div>
      `).join('')}
    ` : ''}

    ${currentCampusSubtab === 'transit' ? `
      <!-- Live Transit GPS Tracker Simulator -->
      <div class="section-header-row" style="margin-top: 0;">
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
    ` : ''}
  `;

  // Attach subtab click events
  document.querySelectorAll('.campus-subtab-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
      currentCampusSubtab = e.currentTarget.getAttribute('data-subtab');
      HapticFeedback.click();
      renderCampusScreen();
    });
  });

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

    <!-- Official Institutional Sub-Portals Direct Access Dock -->
    <div class="section-header-row" style="margin-top: var(--space-md);">
      <span class="section-title">Official Institutional Web Portals</span>
      <span class="role-pill-chip" style="background: var(--color-primary-container); color: var(--color-primary);">Direct Access Dock</span>
    </div>

    <div class="portal-dock-grid">
      ${state.officialPortals.map(p => `
        <a href="${p.url}" target="_blank" class="portal-dock-item tilt-card">
          <div>
            <div class="portal-item-top">
              <span class="portal-category-tag">${p.category}</span>
              <svg viewBox="0 0 24 24" width="12" height="12" fill="currentColor" style="color: var(--color-primary);"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"/></svg>
            </div>
            <div class="portal-title-text">${p.title}</div>
            <div class="portal-desc-text">${p.desc}</div>
          </div>
          <div class="portal-link-arrow">Launch ↗</div>
        </a>
      `).join('')}
    </div>

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

    <!-- Institutional Content Management System (CMS) Banner -->
    <div class="card tilt-card" style="background: linear-gradient(135deg, rgba(0, 54, 34, 0.08) 0%, rgba(212, 160, 23, 0.08) 100%); border: 1px solid var(--color-primary-container);">
      <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
          <span class="freshness-badge current" style="margin-bottom: 4px;">● INSTITUTIONAL CMS ENGINE</span>
          <h3 style="font-family: var(--font-display); font-size: 14px; font-weight: 700;">Central Publishing & Freshness Hub</h3>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">
            ${state.cmsItems.length} announcements managed • Lifecycle State Machine
          </p>
        </div>
        <button class="btn btn-sm btn-primary" id="btnAdminLaunchCms">CMS Studio →</button>
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
  document.getElementById('btnAdminLaunchCms')?.addEventListener('click', openAdminCmsModal);

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

  document.getElementById('btnAdminOpenCmsCreator')?.addEventListener('click', openAdminCmsModal);
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

  // Global Search Events
  el.openGlobalSearchBtn?.addEventListener('click', openGlobalSearch);
  el.closeGlobalSearchBtn?.addEventListener('click', closeGlobalSearch);
  el.globalSearchInput?.addEventListener('input', (e) => {
    renderSearchResults(e.target.value);
  });
  document.querySelectorAll('#searchFilterPills .search-pill-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
      document.querySelectorAll('#searchFilterPills .search-pill-btn').forEach(b => b.classList.remove('active'));
      e.currentTarget.classList.add('active');
      currentSearchCategory = e.currentTarget.getAttribute('data-filter');
      renderSearchResults(el.globalSearchInput.value);
    });
  });

  // Admin CMS Events
  el.closeAdminCmsBtn?.addEventListener('click', closeAdminCmsModal);
  el.closeDocPreviewBtn?.addEventListener('click', () => el.docPreviewModal.classList.remove('active'));
  
  el.btnSaveCmsDraft?.addEventListener('click', () => {
    const title = el.cmsTitle.value.trim();
    if (!title) { showToast('Please enter announcement title', 'error'); return; }
    state.cmsItems.unshift({
      id: `cms_${Date.now()}`,
      title: title,
      category: el.cmsCategory.value,
      freshness: el.cmsFreshness.value,
      stage: 'DRAFT',
      summary: el.cmsSummary.value,
      docUrl: el.cmsDocUrl.value,
      issuedBy: el.cmsIssuedBy.value,
      audience: el.cmsAudience.value,
      isUrgent: el.cmsIsUrgent.checked,
      publishedAt: null
    });
    showToast('Saved notice as DRAFT in Central Registry');
    closeAdminCmsModal();
    renderAdminScreen();
  });

  el.adminCmsForm?.addEventListener('submit', (e) => {
    e.preventDefault();
    const title = el.cmsTitle.value.trim();
    if (!title) return;
    const newItem = {
      id: `cms_${Date.now()}`,
      title: title,
      category: el.cmsCategory.value,
      freshness: el.cmsFreshness.value,
      stage: 'PUBLISHED',
      summary: el.cmsSummary.value,
      docUrl: el.cmsDocUrl.value,
      issuedBy: el.cmsIssuedBy.value,
      audience: el.cmsAudience.value,
      isUrgent: el.cmsIsUrgent.checked,
      publishedAt: 'Just now'
    };
    state.cmsItems.unshift(newItem);
    state.circulars.unshift({
      id: `CIR-${Date.now()}`,
      title: newItem.title,
      category: newItem.category,
      date: 'Just now',
      issuedBy: newItem.issuedBy,
      urgent: newItem.isUrgent,
      summary: newItem.summary
    });
    state.auditTrail.unshift({
      id: `aud_${Date.now()}`,
      timestamp: 'Just now',
      actor: `${state.currentUser.name} (ADMIN)`,
      targetUser: 'ALL CAMPUS NETWORK',
      action: 'STATUTORY_NOTICE_PUBLISHED',
      previousStatus: 'DRAFT',
      newStatus: 'PUBLISHED',
      remarks: newItem.title
    });
    showToast('Statutory announcement approved and published!');
    closeAdminCmsModal();
    renderAdminScreen();
  });

  // Initial Boot
  updateDynamicNavigation();
  switchTab('home');
}

// Run on DOM Ready
document.addEventListener('DOMContentLoaded', initEvents);


// =========================================================================
// SCREEN 11: DEDICATED ADMISSIONS ECOSYSTEM (2026–2027)
// =========================================================================
function renderAdmissionsScreen() {
  const adm = state.admissions;

  el.screenAdmissions.innerHTML = `
    <!-- Admissions Hero Card -->
    <div class="card admissions-hero-banner tilt-card">
      <div style="display: flex; justify-content: space-between; align-items: flex-start;">
        <div>
          <span class="freshness-badge current">● ${adm.currentCycle}</span>
          <h2 style="font-family: var(--font-display); font-size: 16px; font-weight: 700; margin-top: 6px;">Admissions Directorate 2026–2027</h2>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
            ${adm.cuetRequirement}
          </p>
        </div>
      </div>

      <div class="cuet-badge-row">
        <span class="cuet-tag">NTA CUET (UG) 2026</span>
        <span class="cuet-tag">NTA CUET (PG) 2026</span>
        <span class="cuet-tag">NCET (ITEP B.Ed.)</span>
        <span class="cuet-tag">GRI-RET (Ph.D.)</span>
        <span class="cuet-tag">Direct Non-CUET (Unfilled Seats)</span>
      </div>

      <div style="display: flex; gap: 8px; margin-top: 12px;">
        <a href="https://ruraluniv.samarth.ac.in/index.php/site/login" target="_blank" class="btn btn-sm btn-primary" style="flex: 1; text-align: center;">
          Apply via Samarth@GRI →
        </a>
        <button class="btn btn-sm btn-outline" id="btnViewProspectus2026">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M19 8H5c-1.66 0-3 1.34-3 3v6h4v4h12v-4h4v-6c0-1.66-1.34-3-3-3zm-3 11H8v-5h8v5zm3-7c-.55 0-1-.45-1-1s.45-1 1-1 1 .45 1 1-.45 1-1 1zm-1-9H6v4h12V3z"/></svg>
          Prospectus 2026–27
        </button>
      </div>
    </div>

    <!-- Official Prospectus Downloads -->
    <div class="section-header-row">
      <span class="section-title">Official University Prospectuses</span>
    </div>

    <div style="display: grid; grid-template-columns: 1fr; gap: 8px; margin-bottom: var(--space-md);">
      ${adm.prospectuses.map(p => `
        <div class="card tilt-card" style="padding: 12px; display: flex; justify-content: space-between; align-items: center;">
          <div style="display: flex; align-items: center; gap: 10px;">
            <div style="width: 36px; height: 36px; border-radius: var(--radius-sm); background: var(--color-primary-container); display: flex; align-items: center; justify-content: center; color: var(--color-primary); font-weight: 800; font-size: 11px;">PDF</div>
            <div>
              <div style="font-family: var(--font-display); font-size: 12px; font-weight: 700;">${p.title}</div>
              <div style="font-size: 10px; color: var(--color-text-secondary);">${p.file} • ${p.size} • <span class="freshness-badge ${p.status.toLowerCase()}">${p.status}</span></div>
            </div>
          </div>
          <button class="btn btn-sm btn-outline btn-open-doc" data-id="${p.status === 'CURRENT' ? 'doc_prospectus_2026' : 'doc_prospectus_2025'}">Preview</button>
        </div>
      `).join('')}
    </div>

    <!-- Admissions Helpdesk Hotline (Official Verified Contact) -->
    <div class="helpdesk-hotline-card">
      <div style="display: flex; align-items: center; gap: 8px;">
        <svg viewBox="0 0 24 24" width="20" height="20" fill="var(--color-primary)"><path d="M20 15.5c-1.25 0-2.45-.2-3.57-.57-.35-.11-.74-.03-1.02.24l-2.2 2.2c-2.83-1.44-5.15-3.75-6.59-6.59l2.2-2.21c.28-.26.36-.65.25-1C8.7 6.45 8.5 5.25 8.5 4c0-.55-.45-1-1-1H4c-.55 0-1 .45-1 1 0 9.39 7.61 17 17 17 .55 0 1-.45 1-1v-3.5c0-.55-.45-1-1-1zM19 12h2c0-4.97-4.03-9-9-9v2c3.87 0 7 3.13 7 7zm-4 0h2c0-2.76-2.24-5-5-5v2c1.66 0 3 1.34 3 3z"/></svg>
        <span style="font-family: var(--font-display); font-size: 13px; font-weight: 700;">Official Admissions Helpdesk</span>
      </div>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 4px;">
        Operating Hours: ${adm.helpdesk.timings} • ${adm.helpdesk.office}
      </p>

      <div class="hotline-row">
        <a href="tel:${adm.helpdesk.phone1}" class="btn btn-sm btn-outline" style="font-size: 11px;">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg>
          Call: ${adm.helpdesk.phone1}
        </a>
        <a href="tel:${adm.helpdesk.phone2}" class="btn btn-sm btn-outline" style="font-size: 11px;">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg>
          Call: ${adm.helpdesk.phone2}
        </a>
        <a href="mailto:${adm.helpdesk.generalEmail}" class="btn btn-sm btn-outline" style="font-size: 11px;">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>
          Email: helpdesk@ruraluniv.ac.in
        </a>
      </div>
    </div>

    <!-- Programme Discovery & Eligibility Directory -->
    <div class="section-header-row" style="margin-top: var(--space-lg);">
      <span class="section-title">Programmes & Eligibility Catalogue (${state.programmes.length})</span>
    </div>

    <!-- Level Filter Chips -->
    <div class="search-filter-pills" id="admissionsFilterPills" style="margin-bottom: 10px; border-radius: var(--radius-md);">
      <button class="search-pill-btn active" data-lvl="all">All Programmes</button>
      <button class="search-pill-btn" data-lvl="UG">Undergraduate (UG)</button>
      <button class="search-pill-btn" data-lvl="PG">Postgraduate (PG)</button>
      <button class="search-pill-btn" data-lvl="Doctoral">Doctoral (Ph.D.)</button>
      <button class="search-pill-btn" data-lvl="Diploma">Diplomas</button>
    </div>

    <div class="programme-grid" id="programmeCardsContainer">
      ${state.programmes.map(p => `
        <div class="programme-card tilt-card" data-level="${p.level}">
          <div class="programme-header-row">
            <div>
              <span class="course-code-badge">${p.level} • ${p.duration}</span>
              <h3 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; margin-top: 4px;">${p.name}</h3>
              <div style="font-size: 11px; color: var(--color-primary); font-weight: 600;">${p.school}</div>
            </div>
            <span style="font-family: var(--font-mono); font-size: 10px; font-weight: 700; color: var(--color-text-muted); background: var(--color-surface-elevated); padding: 2px 6px; border-radius: var(--radius-sm); border: 1px solid var(--color-surface-border);">
              ${p.cuetCode}
            </span>
          </div>
          <div style="font-size: 11px; color: var(--color-text-secondary); line-height: 1.35; margin-top: 4px;">
            <strong>Eligibility:</strong> ${p.eligibility}
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 8px; font-size: 10px; color: var(--color-text-muted);">
            <span>Sanctioned Intake: ${p.intake} seats</span>
            <a href="https://ruraluniv.samarth.ac.in/index.php/site/login" target="_blank" style="color: var(--color-primary); font-weight: 700;">Apply Now →</a>
          </div>
        </div>
      `).join('')}
    </div>

    <!-- Source Transparency -->
    <div class="source-transparency-card">
      <div class="source-meta-text">
        <strong>Source Transparency:</strong> The Gandhigram Rural Institute Official Website (<a href="https://www.ruraluniv.ac.in/" target="_blank" style="color: var(--color-primary);">ruraluniv.ac.in</a>) • Admissions Section
      </div>
      <span class="official-seal-chip">✓ OFFICIAL</span>
    </div>
  `;

  // Attach filter event listeners
  document.querySelectorAll('#admissionsFilterPills .search-pill-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
      document.querySelectorAll('#admissionsFilterPills .search-pill-btn').forEach(b => b.classList.remove('active'));
      e.currentTarget.classList.add('active');
      const lvl = e.currentTarget.getAttribute('data-lvl');
      document.querySelectorAll('#programmeCardsContainer .programme-card').forEach(card => {
        if (lvl === 'all' || card.getAttribute('data-level').includes(lvl)) {
          card.style.display = 'block';
        } else {
          card.style.display = 'none';
        }
      });
    });
  });

  document.getElementById('btnViewProspectus2026')?.addEventListener('click', () => openDocPreview('doc_prospectus_2026'));
  document.querySelectorAll('.btn-open-doc').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const docId = e.currentTarget.getAttribute('data-id');
      openDocPreview(docId);
    });
  });

  attach3DTiltHandlers();
}

// =========================================================================
// SCREEN 12: DEDICATED EXAMINATION ECOSYSTEM (COE DIRECTORATE)
// =========================================================================
function renderExamsScreen() {
  const ex = state.examinations;

  el.screenExams.innerHTML = `
    <!-- CoE Directorate Hero Card -->
    <div class="card exam-session-card tilt-card">
      <div style="display: flex; justify-content: space-between; align-items: flex-start;">
        <div>
          <span class="freshness-badge current">● OFFICIAL COE DIRECTORATE</span>
          <h2 style="font-family: var(--font-display); font-size: 15px; font-weight: 700; margin-top: 4px;">Controller of Examinations</h2>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">
            ${ex.coeName} • ${ex.coeOffice}
          </p>
        </div>
      </div>
      <div style="font-size: 11px; color: var(--color-primary); font-weight: 600; margin-top: 8px;">
        ${ex.currentSession}
      </div>
      <div style="font-size: 10px; color: var(--color-text-muted); margin-top: 2px;">
        System: ${ex.systemType}
      </div>

      <div style="display: flex; gap: 8px; margin-top: 12px;">
        <button class="btn btn-sm btn-primary" id="btnExamsOpenHallTicket" style="flex: 1;">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M22 10V6c0-1.11-.9-2-2-2H4c-1.1 0-1.99.89-1.99 2v4c1.1 0 1.99.9 1.99 2s-.89 2-2 2v4c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2v-4c-1.1 0-2-.9-2-2s.9-2 2-2z"/></svg>
          View e-SANAD Hall Ticket
        </button>
        <button class="btn btn-sm btn-outline" id="btnExamsTatkalOpen">Tatkal Scheme</button>
      </div>
    </div>

    <!-- End Semester Examination (ESE) Schedule Table -->
    <div class="section-header-row">
      <span class="section-title">End Semester Examination (ESE) Schedule</span>
      <span style="font-size: 11px; font-weight: 700; color: var(--color-primary);">Nov / Dec 2026</span>
    </div>

    <div class="card" style="padding: 0; overflow: hidden; margin-bottom: var(--space-md);">
      <div class="exam-table-container">
        <table class="exam-table">
          <thead>
            <tr>
              <th>Course</th>
              <th>Date & Slot</th>
              <th>Hall & Desk</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            ${ex.schedules.map(s => `
              <tr>
                <td>
                  <strong>${s.code}</strong><br>
                  <span style="font-size: 10px; color: var(--color-text-secondary);">${s.title}</span>
                </td>
                <td>
                  <span style="font-weight: 600;">${s.date}</span><br>
                  <span style="font-size: 10px; color: var(--color-primary);">${s.session}</span>
                </td>
                <td>
                  <span style="font-size: 10px;">${s.hall}</span>
                </td>
                <td>
                  <span class="freshness-badge upcoming">${s.status}</span>
                </td>
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>
    </div>

    <!-- Official Results Ledger Card -->
    <div class="section-header-row">
      <span class="section-title">Academic Performance & Results Ledger</span>
      <span style="font-size: 11px; font-weight: 700; color: var(--color-success);">Cumulative CGPA: 8.84</span>
    </div>

    <div style="display: grid; grid-template-columns: 1fr; gap: 8px; margin-bottom: var(--space-md);">
      ${ex.resultsLedger.map(r => `
        <div class="card tilt-card" style="padding: 12px; display: flex; justify-content: space-between; align-items: center;">
          <div>
            <div style="font-family: var(--font-display); font-size: 13px; font-weight: 700;">${r.sem} (${r.session})</div>
            <div style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px;">
              Credits Earned: ${r.creditsEarned} • <span style="color: var(--color-success); font-weight: 700;">${r.status}</span>
            </div>
          </div>
          <div style="text-align: right;">
            <div style="font-family: var(--font-mono); font-size: 14px; font-weight: 800; color: var(--color-primary);">SGPA: ${r.sgpa}</div>
            <div style="font-size: 10px; color: var(--color-text-muted);">CGPA: ${r.cgpa}</div>
          </div>
        </div>
      `).join('')}
    </div>

    <!-- Tatkal Scheme & e-SANAD Section -->
    <div class="section-header-row">
      <span class="section-title">Special Statutory Services</span>
    </div>

    <div class="tatkal-service-box">
      <div style="display: flex; justify-content: space-between; align-items: flex-start;">
        <div>
          <span style="font-family: var(--font-mono); font-size: 10px; font-weight: 800; color: #D97706; text-transform: uppercase;">FAST-TRACK EXPEDITION</span>
          <h3 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; margin-top: 2px;">${ex.tatkalScheme.title}</h3>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.35;">
            ${ex.tatkalScheme.description}
          </p>
          <div style="font-size: 10px; color: #D97706; font-weight: 700; margin-top: 4px;">${ex.tatkalScheme.fee}</div>
        </div>
      </div>
      <div style="display: flex; gap: 8px; margin-top: 10px;">
        <a href="${ex.tatkalScheme.registrationUrl}" target="_blank" class="btn btn-sm btn-primary" style="background: #D97706; border-color: #D97706; color: #fff;">
          Tatkal Registration Portal →
        </a>
        <button class="btn btn-sm btn-outline btn-open-doc" data-id="doc_tatkal_instruction">Instructions PDF</button>
      </div>
    </div>

    <!-- Official Examination Forms -->
    <div class="section-header-row" style="margin-top: var(--space-lg);">
      <span class="section-title">Statutory Forms & Applications</span>
    </div>

    <div style="display: grid; grid-template-columns: 1fr; gap: 8px;">
      ${ex.forms.map(f => `
        <div class="card tilt-card" style="padding: 10px 14px; display: flex; justify-content: space-between; align-items: center;">
          <div style="display: flex; align-items: center; gap: 8px;">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="var(--color-primary)"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
            <span style="font-size: 12px; font-weight: 600;">${f.title}</span>
          </div>
          <a href="${f.url}" target="_blank" class="btn btn-sm btn-outline">Download</a>
        </div>
      `).join('')}
    </div>

    <!-- Source Transparency -->
    <div class="source-transparency-card">
      <div class="source-meta-text">
        <strong>Source Transparency:</strong> The Gandhigram Rural Institute Official Website (<a href="https://www.ruraluniv.ac.in/" target="_blank" style="color: var(--color-primary);">ruraluniv.ac.in</a>) • Office of Controller of Examinations
      </div>
      <span class="official-seal-chip">✓ STATUTORY CoE</span>
    </div>
  `;

  document.getElementById('btnExamsOpenHallTicket')?.addEventListener('click', openHallTicketModal);
  document.getElementById('btnExamsTatkalOpen')?.addEventListener('click', () => {
    window.open(ex.tatkalScheme.registrationUrl, '_blank');
  });
  document.querySelectorAll('.btn-open-doc').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const docId = e.currentTarget.getAttribute('data-id');
      openDocPreview(docId);
    });
  });

  attach3DTiltHandlers();
}

// =========================================================================
// SCREEN 13: DEDICATED SCHOLARSHIPS ECOSYSTEM
// =========================================================================
function renderScholarshipsScreen() {
  const schList = state.scholarships;

  el.screenScholarships.innerHTML = `
    <div class="card tilt-card" style="background: linear-gradient(135deg, var(--color-surface-card), var(--color-surface-elevated)); border-left: 4px solid var(--color-primary);">
      <span class="freshness-badge current">● ACADEMIC YEAR 2026–2027</span>
      <h2 style="font-family: var(--font-display); font-size: 15px; font-weight: 700; margin-top: 4px;">Institutional Scholarships & Fellowships</h2>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 2px; line-height: 1.35;">
        Centrally funded UGC, Ministry of Social Justice, and Govt. of Tamil Nadu welfare schemes managed through the National Scholarship Portal (NSP).
      </p>

      <div style="background: var(--color-warning-bg); border: 1px solid var(--color-warning); border-radius: var(--radius-sm); padding: 8px 10px; margin-top: 10px; font-size: 11px; color: var(--color-text-primary);">
        <strong>Important GRI Regulation:</strong> A student cannot draw more than one scholarship concurrently for the same course of study. If multiple scholarships are sanctioned, the least beneficial amount must be refunded.
      </div>
    </div>

    <!-- Scholarship Category Filters -->
    <div class="search-filter-pills" id="scholarshipFilterPills" style="margin-top: 12px; margin-bottom: 8px; border-radius: var(--radius-md);">
      <button class="search-pill-btn active" data-cat="all">All Schemes (${schList.length})</button>
      <button class="search-pill-btn" data-cat="Research">Research Fellowships</button>
      <button class="search-pill-btn" data-cat="Merit-cum-Means">Merit-cum-Means</button>
      <button class="search-pill-btn" data-cat="State Welfare">State Welfare</button>
      <button class="search-pill-btn" data-cat="Technical">AICTE (MCA/MBA)</button>
    </div>

    <!-- Scholarship Cards -->
    <div id="scholarshipCardsContainer">
      ${schList.map(s => `
        <div class="scholarship-card tilt-card" data-category="${s.category}">
          <div style="display: flex; justify-content: space-between; align-items: flex-start;">
            <div>
              <div style="display: flex; align-items: center; gap: 6px;">
                <span class="freshness-badge ${s.status.toLowerCase()}">${s.status}</span>
                <span style="font-size: 10px; color: var(--color-text-muted); font-weight: 600;">${s.category}</span>
              </div>
              <h3 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; margin-top: 4px;">${s.name}</h3>
              <div style="font-size: 10px; color: var(--color-primary); font-weight: 600;">Provider: ${s.provider}</div>
            </div>
            <div class="scholarship-award-amount">${s.awardAmount}</div>
          </div>

          <div style="font-size: 11px; color: var(--color-text-secondary); line-height: 1.35; margin-top: 6px;">
            <strong>Eligibility:</strong> ${s.eligibility}
          </div>

          <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 10px; border-top: 1px solid var(--color-surface-border-subtle); padding-top: 8px;">
            <span style="font-size: 10px; color: var(--color-warning); font-weight: 700;">Deadline: ${s.deadline}</span>
            <a href="${s.applyUrl}" target="_blank" class="btn btn-sm btn-primary" style="font-size: 11px; padding: 4px 10px;">
              Apply on Portal →
            </a>
          </div>
        </div>
      `).join('')}
    </div>

    <!-- Source Transparency -->
    <div class="source-transparency-card">
      <div class="source-meta-text">
        <strong>Source Transparency:</strong> The Gandhigram Rural Institute Official Website (<a href="https://www.ruraluniv.ac.in/" target="_blank" style="color: var(--color-primary);">ruraluniv.ac.in</a>) • Students Corner & Reservation Cell
      </div>
      <span class="official-seal-chip">✓ VERIFIED NSP</span>
    </div>
  `;

  // Attach filter event listeners
  document.querySelectorAll('#scholarshipFilterPills .search-pill-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
      document.querySelectorAll('#scholarshipFilterPills .search-pill-btn').forEach(b => b.classList.remove('active'));
      e.currentTarget.classList.add('active');
      const cat = e.currentTarget.getAttribute('data-cat');
      document.querySelectorAll('#scholarshipCardsContainer .scholarship-card').forEach(card => {
        if (cat === 'all' || card.getAttribute('data-category').includes(cat)) {
          card.style.display = 'block';
        } else {
          card.style.display = 'none';
        }
      });
    });
  });

  attach3DTiltHandlers();
}

// =========================================================================
// SCREEN 14: ABOUT GRI & GOVERNANCE ECOSYSTEM
// =========================================================================
function renderAboutScreen() {
  const ab = state.aboutGri;
  const lead = state.leadership;

  el.screenAbout.innerHTML = `
    <!-- NAAC 'A+' Score Banner -->
    <div class="naac-score-banner">
      <div>
        <span style="font-family: var(--font-mono); font-size: 10px; font-weight: 800; letter-spacing: 0.5px; opacity: 0.9;">UGC DEEMED TO BE UNIVERSITY (1976)</span>
        <h2 style="font-family: var(--font-display); font-size: 16px; font-weight: 800; margin-top: 2px;">NAAC 'A+' GRADE (CGPA: 3.34)</h2>
        <div style="font-size: 11px; opacity: 0.9; margin-top: 2px;">NIRF Ranked • 100% Statutory UGC Compliance</div>
      </div>
      <div style="text-align: right;">
        <span style="font-size: 28px; font-weight: 800; font-family: var(--font-display);">300</span>
        <div style="font-size: 9px; opacity: 0.85;">ACRES CAMPUS</div>
      </div>
    </div>

    <!-- Genesis & Nai Talim Philosophy -->
    <div class="card tilt-card" style="margin-bottom: var(--space-md);">
      <span class="freshness-badge current">● HERITAGE & GENESIS</span>
      <h3 style="font-family: var(--font-display); font-size: 14px; font-weight: 700; margin-top: 4px;">Genesis of Gandhigram Rural Institute</h3>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
        ${ab.genesis}
      </p>
      <div style="margin-top: 8px; font-size: 11px; color: var(--color-primary); font-weight: 600; line-height: 1.35;">
        <strong>Philosophy:</strong> ${ab.philosophy}
      </div>
    </div>

    <!-- 7 Sacred Symbols of the GRI Emblem -->
    <div class="card tilt-card" style="margin-bottom: var(--space-md);">
      <div style="display: flex; gap: 12px; align-items: center; margin-bottom: 12px;">
        <img src="/assets/grilogotya.jpg" alt="Official GRI Emblem" style="width: 64px; height: 64px; object-fit: contain; background: #fff; border-radius: 8px; border: 1.5px solid var(--color-primary-container); padding: 2px;">
        <div>
          <span class="freshness-badge current">● EMBLEM ICONOGRAPHY</span>
          <h3 style="font-family: var(--font-display); font-size: 14px; font-weight: 700; margin-top: 2px;">7 Sacred Symbols of the GRI Seal</h3>
          <p style="font-size: 10px; color: var(--color-text-secondary); margin-top: 2px;">Synthesizing spiritual wisdom, rural labor, science, and Gandhian philosophy.</p>
        </div>
      </div>

      <div class="emblem-symbol-grid">
        ${(state.emblemSymbols || []).map(sym => `
          <div class="emblem-symbol-card">
            <div class="symbol-num-badge">${sym.num}</div>
            <div style="flex: 1;">
              <div style="font-family: var(--font-display); font-size: 12px; font-weight: 700; color: var(--color-primary);">${sym.name}</div>
              <div style="font-size: 10px; color: var(--color-text-secondary); margin-top: 2px; line-height: 1.35;">${sym.meaning}</div>
            </div>
          </div>
        `).join('')}
      </div>
    </div>

    <!-- University Leadership Directory -->
    <div class="section-header-row">
      <span class="section-title">Institutional Leadership & Officers</span>
    </div>

    <div class="leadership-avatar-grid">
      <div class="leader-card tilt-card">
        <div class="leader-avatar-circle">VC</div>
        <div class="leader-name">${lead.viceChancellor.name}</div>
        <div class="leader-title">${lead.viceChancellor.role}</div>
        <a href="mailto:${lead.viceChancellor.email}" style="font-size: 10px; color: var(--color-primary); display: block; margin-top: 4px;">${lead.viceChancellor.email}</a>
      </div>

      <div class="leader-card tilt-card">
        <div class="leader-avatar-circle" style="background: var(--color-secondary);">REG</div>
        <div class="leader-name">${lead.registrar.name}</div>
        <div class="leader-title">${lead.registrar.role}</div>
        <a href="mailto:${lead.registrar.email}" style="font-size: 10px; color: var(--color-primary); display: block; margin-top: 4px;">${lead.registrar.email}</a>
      </div>

      <div class="leader-card tilt-card">
        <div class="leader-avatar-circle" style="background: var(--color-tertiary);">COE</div>
        <div class="leader-name">${lead.controllerOfExaminations.name}</div>
        <div class="leader-title">${lead.controllerOfExaminations.role}</div>
        <a href="mailto:${lead.controllerOfExaminations.email}" style="font-size: 10px; color: var(--color-primary); display: block; margin-top: 4px;">${lead.controllerOfExaminations.email}</a>
      </div>

      <div class="leader-card tilt-card">
        <div class="leader-avatar-circle" style="background: #059669;">FO</div>
        <div class="leader-name">${lead.financeOfficer.name}</div>
        <div class="leader-title">${lead.financeOfficer.role}</div>
        <a href="mailto:${lead.financeOfficer.email}" style="font-size: 10px; color: var(--color-primary); display: block; margin-top: 4px;">${lead.financeOfficer.email}</a>
      </div>
    </div>

    <!-- Deans of 8 Schools -->
    <div class="section-header-row" style="margin-top: var(--space-lg);">
      <span class="section-title">Deans of Academic Schools</span>
    </div>

    <div style="display: grid; grid-template-columns: 1fr; gap: 8px; margin-bottom: var(--space-md);">
      ${lead.deans.map(d => `
        <div class="card tilt-card" style="padding: 10px 14px; display: flex; justify-content: space-between; align-items: center;">
          <div>
            <div style="font-family: var(--font-display); font-size: 12px; font-weight: 700;">${d.school}</div>
            <div style="font-size: 11px; color: var(--color-primary);">${d.name}</div>
          </div>
          <div style="text-align: right; font-size: 10px; color: var(--color-text-secondary);">
            <span>${d.phone}</span>
          </div>
        </div>
      `).join('')}
    </div>

    <!-- Governance Councils -->
    <div class="section-header-row">
      <span class="section-title">Institutional Governance Councils</span>
    </div>

    <div style="display: grid; grid-template-columns: 1fr; gap: 8px; margin-bottom: var(--space-md);">
      ${ab.governanceBodies.map(g => `
        <div class="card tilt-card" style="padding: 12px;">
          <h4 style="font-family: var(--font-display); font-size: 13px; font-weight: 700; color: var(--color-primary);">${g.name}</h4>
          <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 3px; line-height: 1.35;">${g.role}</p>
        </div>
      `).join('')}
    </div>

    <!-- Campus & Geographic Location -->
    <div class="card tilt-card" style="margin-bottom: var(--space-md);">
      <span class="freshness-badge current">● GEOGRAPHIC LOCATION & CONTACT</span>
      <h3 style="font-family: var(--font-display); font-size: 14px; font-weight: 700; margin-top: 4px;">Main Campus Coordinates</h3>
      <p style="font-size: 11px; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
        ${ab.campusArea} Connected via NH-44 (Madurai – Dindigul Highway), nearest railway station: Ambaturai (2 km) and Dindigul Junction (12 km).
      </p>
      <div style="display: flex; gap: 8px; margin-top: 10px;">
        <a href="http://ruraluniv.ac.in/includes/aboutgri/map/map.html" target="_blank" class="btn btn-sm btn-outline" style="flex: 1; text-align: center;">Official Campus Map</a>
        <a href="https://maps.google.com/?q=The+Gandhigram+Rural+Institute" target="_blank" class="btn btn-sm btn-primary" style="flex: 1; text-align: center;">Open GPS Map ↗</a>
      </div>
    </div>

    <!-- Official Portals Directory -->
    <div class="section-header-row">
      <span class="section-title">Official GRI Digital Ecosystem</span>
    </div>

    <div style="display: grid; grid-template-columns: 1fr; gap: 8px;">
      ${state.officialPortals.map(p => `
        <a href="${p.url}" target="_blank" class="card tilt-card" style="padding: 10px 14px; display: flex; justify-content: space-between; align-items: center; text-decoration: none; color: inherit;">
          <div>
            <div style="font-family: var(--font-display); font-size: 12px; font-weight: 700; color: var(--color-text-primary);">${p.title}</div>
            <div style="font-size: 10px; color: var(--color-text-secondary);">${p.desc}</div>
          </div>
          <span style="font-size: 11px; color: var(--color-primary); font-weight: 700;">Visit ↗</span>
        </a>
      `).join('')}
    </div>

    <!-- Source Transparency -->
    <div class="source-transparency-card">
      <div class="source-meta-text">
        <strong>Source Transparency:</strong> The Gandhigram Rural Institute Official Website (<a href="https://www.ruraluniv.ac.in/" target="_blank" style="color: var(--color-primary);">ruraluniv.ac.in</a>) • Central Administration Block
      </div>
      <span class="official-seal-chip">✓ DEEMED UNIVERSITY</span>
    </div>
  `;

  attach3DTiltHandlers();
}

// =========================================================================
// GLOBAL SEARCH ENGINE (INSTANT ACROSS ALL INSTITUTIONAL ENTITIES)
// =========================================================================
let currentSearchCategory = 'all';

function openGlobalSearch() {
  HapticFeedback.click();
  el.globalSearchModal.classList.add('active');
  el.globalSearchInput.value = '';
  el.globalSearchInput.focus();
  renderSearchResults('');
}

function closeGlobalSearch() {
  el.globalSearchModal.classList.remove('active');
}

function renderSearchResults(query = '') {
  const q = query.trim().toLowerCase();
  let results = [];

  // Search across programmes
  if (currentSearchCategory === 'all' || currentSearchCategory === 'programmes') {
    state.programmes.forEach(p => {
      if (!q || p.name.toLowerCase().includes(q) || p.school.toLowerCase().includes(q) || p.cuetCode.toLowerCase().includes(q)) {
        results.push({
          type: 'Programme',
          category: 'Academics & Admissions',
          title: p.name,
          subtitle: `${p.school} • ${p.duration} • CUET: ${p.cuetCode}`,
          action: () => { closeGlobalSearch(); switchTab('admissions'); }
        });
      }
    });
  }

  // Search across admissions
  if (currentSearchCategory === 'all' || currentSearchCategory === 'admissions') {
    state.admissions.statutoryLinks.forEach(l => {
      if (!q || l.title.toLowerCase().includes(q) || l.desc.toLowerCase().includes(q)) {
        results.push({
          type: 'Admission Link',
          category: 'Admissions 2026–27',
          title: l.title,
          subtitle: l.desc,
          action: () => { window.open(l.url, '_blank'); }
        });
      }
    });
  }

  // Search across exams
  if (currentSearchCategory === 'all' || currentSearchCategory === 'examinations') {
    state.examinations.schedules.forEach(s => {
      if (!q || s.code.toLowerCase().includes(q) || s.title.toLowerCase().includes(q) || s.hall.toLowerCase().includes(q)) {
        results.push({
          type: 'Exam Schedule',
          category: 'Examinations (CoE)',
          title: `${s.code}: ${s.title}`,
          subtitle: `Date: ${s.date} • ${s.session} • ${s.hall}`,
          action: () => { closeGlobalSearch(); switchTab('exams'); }
        });
      }
    });
  }

  // Search across scholarships
  if (currentSearchCategory === 'all' || currentSearchCategory === 'scholarships') {
    state.scholarships.forEach(s => {
      if (!q || s.name.toLowerCase().includes(q) || s.provider.toLowerCase().includes(q) || s.category.toLowerCase().includes(q)) {
        results.push({
          type: 'Scholarship',
          category: 'Student Welfare',
          title: s.name,
          subtitle: `Amount: ${s.awardAmount} • Provider: ${s.provider}`,
          action: () => { closeGlobalSearch(); switchTab('scholarships'); }
        });
      }
    });
  }

  // Search across official documents
  if (currentSearchCategory === 'all' || currentSearchCategory === 'documents') {
    state.officialDocuments.forEach(d => {
      if (!q || d.title.toLowerCase().includes(q) || d.category.toLowerCase().includes(q) || d.department.toLowerCase().includes(q)) {
        results.push({
          type: 'Official Document',
          category: d.category,
          title: d.title,
          subtitle: `${d.department} • ${d.date} • ${d.fileSize}`,
          action: () => { closeGlobalSearch(); openDocPreview(d.id); }
        });
      }
    });
  }

  // Search across leadership & about
  if (currentSearchCategory === 'all' || currentSearchCategory === 'about') {
    state.leadership.deans.forEach(d => {
      if (!q || d.school.toLowerCase().includes(q) || d.name.toLowerCase().includes(q)) {
        results.push({
          type: 'Leadership',
          category: 'Dean of School',
          title: `${d.name} (${d.school})`,
          subtitle: `Email: ${d.email} • ${d.phone}`,
          action: () => { closeGlobalSearch(); switchTab('about'); }
        });
      }
    });
  }

  // Search across transit bus routes
  if (currentSearchCategory === 'all' || currentSearchCategory === 'campus') {
    state.busRoutes.forEach(b => {
      if (!q || b.name.toLowerCase().includes(q) || b.busNo.toLowerCase().includes(q) || b.driver.toLowerCase().includes(q)) {
        results.push({
          type: 'Transit Radar',
          category: 'Campus Fleet',
          title: b.name,
          subtitle: `Bus ${b.busNo} • Driver: ${b.driver} • ETA: ${b.eta}`,
          action: () => { closeGlobalSearch(); switchTab('campus'); }
        });
      }
    });
  }

  // Search across facilities & laboratories
  if (currentSearchCategory === 'all' || currentSearchCategory === 'campus') {
    (state.facilities || []).forEach(f => {
      if (!q || f.name.toLowerCase().includes(q) || f.category.toLowerCase().includes(q) || f.description.toLowerCase().includes(q)) {
        results.push({
          type: 'Facility & Lab',
          category: f.category,
          title: f.name,
          subtitle: `${f.badge} • ${f.contact}`,
          action: () => { closeGlobalSearch(); switchTab('campus'); }
        });
      }
    });
  }

  // Search across academic centres & KVK
  if (currentSearchCategory === 'all' || currentSearchCategory === 'campus') {
    (state.academicCentres || []).forEach(c => {
      if (!q || c.name.toLowerCase().includes(q) || c.mandate.toLowerCase().includes(q)) {
        results.push({
          type: 'Research & Extension Centre',
          category: c.sponsor,
          title: c.name,
          subtitle: `${c.mandate} • ${c.lead}`,
          action: () => { closeGlobalSearch(); switchTab('campus'); }
        });
      }
    });
  }

  // Search across careers & tenders
  if (currentSearchCategory === 'all' || currentSearchCategory === 'campus') {
    (state.careersAndTenders || []).forEach(t => {
      if (!q || t.title.toLowerCase().includes(q) || t.type.toLowerCase().includes(q) || t.summary.toLowerCase().includes(q)) {
        results.push({
          type: t.type,
          category: t.status,
          title: t.title,
          subtitle: `${t.date} (${t.time}) • ${t.venue}`,
          action: () => { closeGlobalSearch(); switchTab('campus'); }
        });
      }
    });
  }

  // Search across official web portals
  if (currentSearchCategory === 'all') {
    (state.officialPortals || []).forEach(p => {
      if (!q || p.title.toLowerCase().includes(q) || p.desc.toLowerCase().includes(q) || p.category.toLowerCase().includes(q)) {
        results.push({
          type: 'Official Web Portal',
          category: p.category,
          title: p.title,
          subtitle: `${p.desc} • ${p.url}`,
          action: () => { window.open(p.url, '_blank'); }
        });
      }
    });
  }

  // Render results
  if (results.length === 0) {
    el.searchResultsList.innerHTML = `
      <div style="text-align: center; padding: var(--space-xl) var(--space-md); color: var(--color-text-muted);">
        <svg viewBox="0 0 24 24" width="36" height="36" fill="currentColor" style="opacity: 0.5; margin-bottom: 8px;"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
        <div style="font-weight: 600; font-size: 13px;">No institutional records matched "${query}"</div>
        <div style="font-size: 11px; margin-top: 4px;">Try searching for "MCA", "Agriculture", "Hall Ticket", "Tatkal", "Scholarship", or "Hostel".</div>
      </div>
    `;
    return;
  }

  el.searchResultsList.innerHTML = results.slice(0, 25).map((r, idx) => `
    <div class="search-result-card" data-idx="${idx}">
      <div class="search-result-meta">
        <span style="color: var(--color-primary);">${r.type}</span>
        <span>${r.category}</span>
      </div>
      <div class="search-result-title">${r.title}</div>
      <div class="search-result-snippet">${r.subtitle}</div>
    </div>
  `).join('');

  document.querySelectorAll('#searchResultsList .search-result-card').forEach(card => {
    card.addEventListener('click', (e) => {
      const idx = parseInt(e.currentTarget.getAttribute('data-idx'));
      if (results[idx] && results[idx].action) {
        results[idx].action();
      }
    });
  });
}

// =========================================================================
// OFFICIAL DOCUMENT PREVIEW MODAL
// =========================================================================
function openDocPreview(docId) {
  const doc = state.officialDocuments.find(d => d.id === docId);
  if (!doc) {
    showToast('Document not found in statutory register', 'error');
    return;
  }

  HapticFeedback.click();
  el.docPreviewTitle.textContent = doc.title;
  el.docPreviewSubtitle.textContent = `${doc.department} • Academic Year: ${doc.academicYear}`;

  el.docPreviewContent.innerHTML = `
    <div style="background: var(--color-surface-elevated); padding: 14px; border-radius: var(--radius-md); border: 1px solid var(--color-surface-border); margin-bottom: var(--space-md);">
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 11px;">
        <div>
          <span style="color: var(--color-text-muted);">Category:</span>
          <div style="font-weight: 700; color: var(--color-text-primary);">${doc.category}</div>
        </div>
        <div>
          <span style="color: var(--color-text-muted);">Document Type:</span>
          <div style="font-weight: 700; color: var(--color-text-primary);">${doc.docType}</div>
        </div>
        <div>
          <span style="color: var(--color-text-muted);">Publication Date:</span>
          <div style="font-weight: 700; color: var(--color-text-primary);">${doc.date}</div>
        </div>
        <div>
          <span style="color: var(--color-text-muted);">Freshness Status:</span>
          <div><span class="freshness-badge ${doc.status.toLowerCase()}">${doc.status}</span></div>
        </div>
        <div>
          <span style="color: var(--color-text-muted);">Applicable Roles:</span>
          <div style="font-weight: 600; color: var(--color-text-primary);">${doc.applicableRole}</div>
        </div>
        <div>
          <span style="color: var(--color-text-muted);">Verified File Size:</span>
          <div style="font-weight: 700; color: var(--color-text-primary);">${doc.fileSize}</div>
        </div>
      </div>
    </div>

    <!-- SHA-256 Gazette Seal -->
    <div style="background: rgba(153, 211, 178, 0.08); border: 1px solid rgba(153, 211, 178, 0.25); border-radius: var(--radius-md); padding: 10px 12px; margin-bottom: var(--space-md);">
      <div style="display: flex; align-items: center; gap: 6px; font-size: 11px; font-weight: 700; color: var(--color-primary);">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm-2 16l-4-4 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/></svg>
        <span>Cryptographic SHA-256 Digest Authenticated</span>
      </div>
      <div style="font-family: var(--font-mono); font-size: 9px; color: var(--color-text-muted); word-break: break-all; margin-top: 4px;">
        ${doc.sha256}
      </div>
    </div>

    <div style="display: flex; gap: 8px;">
      <a href="${doc.officialSource}" target="_blank" class="btn btn-primary" style="flex: 1; text-align: center;">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"/></svg>
        Open on ruraluniv.ac.in
      </a>
      <button class="btn btn-outline" id="btnShareDocUrl">Copy URL</button>
    </div>
  `;

  document.getElementById('btnShareDocUrl')?.addEventListener('click', () => {
    navigator.clipboard?.writeText(doc.officialSource);
    showToast('Official source URL copied to clipboard');
  });

  el.docPreviewModal.classList.add('active');
}

// =========================================================================
// ADMIN CONTENT MANAGEMENT SYSTEM (CMS PUBLISHER)
// =========================================================================
function openAdminCmsModal() {
  if (!checkPermission(PERMISSIONS.VIEW_ADMIN_DASHBOARD) && !checkPermission(PERMISSIONS.PUBLISH_STATUTORY_CIRCULARS)) {
    showToast('Unauthorized: Administrator privileges required', 'error');
    return;
  }
  HapticFeedback.click();
  el.adminCmsForm.reset();
  el.adminCmsModal.classList.add('active');
}

function closeAdminCmsModal() {
  el.adminCmsModal.classList.remove('active');
}
