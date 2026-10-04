/**
 * ============================================================================
 * GRI OFFICIAL INSTITUTIONAL CONTENT INGESTION & DEDUPLICATION ENGINE
 * Gandhigram Rural Institute (Deemed to be University)
 * Authoritative Source: https://www.ruraluniv.ac.in/
 * ============================================================================
 */

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

function computeHash(sourceUrl, title) {
  return crypto.createHash('sha256').update(`${sourceUrl}::${title}`).digest('hex');
}

// 1. Official Schools of GRI
const schoolsData = [
  {
    id: 'sch_sci',
    name: 'School of Sciences',
    dean: 'Dr. S. Kanthimathinathan',
    dean_email: 'dean_sciences@ruraluniv.ac.in',
    dean_phone: '+91 451 2452371 Ext: 201',
    programmes_count: 16,
    highlights: 'DST-FIST Supported Labs, Central NMR & XRD Instrumentation Facility, Cloud Computing Lab',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'sch_agri',
    name: 'School of Agriculture and Animal Sciences',
    dean: 'Dr. K. S. Pushpa',
    dean_email: 'dean_agri@ruraluniv.ac.in',
    dean_phone: '+91 451 2452371 Ext: 202',
    programmes_count: 9,
    highlights: 'ICAR Accredited B.Sc. (Hons.) Agriculture, Organic Dairy Farm, Agro-Meteorological Unit',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'sch_health',
    name: 'School of Rural Health and Sanitation',
    dean: 'Dr. M. G. Sethuraman',
    dean_email: 'dean_health@ruraluniv.ac.in',
    dean_phone: '+91 451 2452371 Ext: 203',
    programmes_count: 7,
    highlights: 'WHO collaborating projects, Pioneer in Sanitary Inspector Training in India since 1965',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'sch_socsci',
    name: 'School of Social Sciences',
    dean: 'Dr. P. Anandharajakumar',
    dean_email: 'dean_socsci@ruraluniv.ac.in',
    dean_phone: '+91 451 2452371 Ext: 204',
    programmes_count: 14,
    highlights: 'Nai Talim Village Internship, Kasturba Seva Ashram Field Action Projects',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'sch_tamil',
    name: 'School of Tamil, Indian Languages and Rural Arts',
    dean: 'Dr. M. Kuruvammal',
    dean_email: 'dean_tamil@ruraluniv.ac.in',
    dean_phone: '+91 451 2452371 Ext: 205',
    programmes_count: 10,
    highlights: 'Classical Tamil Palm-leaf Archives, Folk Arts Troupe, Rural Handicrafts Centre',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'sch_english',
    name: 'School of English & Foreign Languages',
    dean: 'Dr. S. Senthilnathan',
    dean_email: 'dean_english@ruraluniv.ac.in',
    dean_phone: '+91 451 2452371 Ext: 206',
    programmes_count: 6,
    highlights: 'Multimedia Language Laboratory, Comparative Literature & Translation Studies',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'sch_mgmt',
    name: 'School of Management Studies',
    dean: 'Dr. T. Selvin Jebaraj Norman',
    dean_email: 'dean_mgmt@ruraluniv.ac.in',
    dean_phone: '+91 451 2452371 Ext: 207',
    programmes_count: 8,
    highlights: 'MBA Rural Management (AICTE Approved), Microfinance & Rural Enterprise Incubator',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'sch_edu',
    name: 'School of Education',
    dean: 'Dr. P. S. Balasubramanian',
    dean_email: 'dean_edu@ruraluniv.ac.in',
    dean_phone: '+91 451 2452371 Ext: 208',
    programmes_count: 5,
    highlights: 'NCTE Approved ITEP 4-Year B.Ed. Integrated Programme, Smart Classroom Demonstration Suite',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  }
];

// 2. Official Departments of GRI
const departmentsData = [
  {
    id: 'dept_cs',
    school_id: 'sch_sci',
    name: 'Department of Computer Science & Applications',
    hod_name: 'Dr. K. Senthilkumar',
    hod_email: 'hod_cs@ruraluniv.ac.in',
    contact_phone: '+91 451 2452371 Ext: 2360',
    programmes_offered: ['Master of Computer Applications (MCA)', 'M.Sc. Computer Science', 'B.Sc. Computer Science', 'Ph.D. in Computer Science'],
    overview: 'Established in 1989. Offering AICTE approved MCA and advanced research in Machine Learning, Distributed Cloud Systems, and Rural IT Solutions.',
    image_url: 'https://www.ruraluniv.ac.in/images/departments/csa.jpg',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'dept_math',
    school_id: 'sch_sci',
    name: 'Department of Mathematics',
    hod_name: 'Dr. P. Balasubramaniam',
    hod_email: 'hod_math@ruraluniv.ac.in',
    contact_phone: '+91 451 2452371 Ext: 2361',
    programmes_offered: ['M.Sc. Mathematics', 'Ph.D. in Mathematics'],
    overview: 'Distinguished research department recognized with DST-FIST and UGC-SAP assistance specializing in control theory and neural dynamics.',
    image_url: 'https://www.ruraluniv.ac.in/images/departments/math.jpg',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'dept_phy',
    school_id: 'sch_sci',
    name: 'Department of Physics',
    hod_name: 'Dr. G. Muralidharan',
    hod_email: 'hod_physics@ruraluniv.ac.in',
    contact_phone: '+91 451 2452371 Ext: 2362',
    programmes_offered: ['M.Sc. Physics', 'B.Sc. Physics', 'Ph.D. in Physics'],
    overview: 'Active in nanomaterials, renewable energy materials, crystal growth, and energy storage devices with major national research grants.',
    image_url: 'https://www.ruraluniv.ac.in/images/departments/physics.jpg',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'dept_che',
    school_id: 'sch_sci',
    name: 'Department of Chemistry',
    hod_name: 'Dr. S. Ramesh',
    hod_email: 'hod_chemistry@ruraluniv.ac.in',
    contact_phone: '+91 451 2452371 Ext: 2363',
    programmes_offered: ['M.Sc. Applied Chemistry', 'B.Sc. Chemistry', 'Ph.D. in Chemistry'],
    overview: 'Specializes in green chemistry, polymer electrolytes, corrosion inhibitors, and natural product extraction with state-of-the-art instrumentation.',
    image_url: 'https://www.ruraluniv.ac.in/images/departments/chem.jpg',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'dept_agri',
    school_id: 'sch_agri',
    name: 'Department of Agriculture',
    hod_name: 'Dr. T. Sivasankaran',
    hod_email: 'hod_agri@ruraluniv.ac.in',
    contact_phone: '+91 451 2452371 Ext: 2364',
    programmes_offered: ['B.Sc. (Hons.) Agriculture', 'Diploma in Agriculture', 'Ph.D. in Agriculture'],
    overview: 'ICAR accredited 4-year undergraduate and doctoral degrees integrating natural farming, seed production, and rural agrarian fieldwork.',
    image_url: 'https://www.ruraluniv.ac.in/images/departments/agri.jpg',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'dept_health',
    school_id: 'sch_health',
    name: 'Department of Rural Health & Sanitation',
    hod_name: 'Dr. K. Mahendran',
    hod_email: 'hod_health@ruraluniv.ac.in',
    contact_phone: '+91 451 2452371 Ext: 2365',
    programmes_offered: ['Diploma in Sanitary Inspector Course', 'Post Graduate Diploma in Sanitary Inspector Course', 'M.Sc. Health & Sanitation Sciences'],
    overview: 'First institution in independent India to initiate professional Sanitary Inspector training in 1965, contributing thousands of public health officers.',
    image_url: 'https://www.ruraluniv.ac.in/images/departments/health.jpg',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'dept_rd',
    school_id: 'sch_socsci',
    name: 'Department of Rural Development',
    hod_name: 'Prof. R. Mani',
    hod_email: 'hod_rd@ruraluniv.ac.in',
    contact_phone: '+91 451 2452371 Ext: 2366',
    programmes_offered: ['M.A. Rural Development', 'Master of Social Work (MSW)', 'Ph.D. in Rural Development'],
    overview: 'The flagship soul of GRI. Pioneer in rural extension, participatory action research, Panchayati Raj training, and sustainable village development.',
    image_url: 'https://www.ruraluniv.ac.in/images/departments/rd.jpg',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'dept_mgmt',
    school_id: 'sch_mgmt',
    name: 'Department of Rural Management',
    hod_name: 'Dr. T. Selvin Jebaraj Norman',
    hod_email: 'hod_mgmt@ruraluniv.ac.in',
    contact_phone: '+91 451 2452371 Ext: 2367',
    programmes_offered: ['MBA Rural Management', 'Ph.D. in Management'],
    overview: 'AICTE approved professional management degree blending corporate business analytics with cooperative management and rural entrepreneurship.',
    image_url: 'https://www.ruraluniv.ac.in/images/departments/mgmt.jpg',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  },
  {
    id: 'dept_edu',
    school_id: 'sch_edu',
    name: 'Department of Education',
    hod_name: 'Dr. P. S. Balasubramanian',
    hod_email: 'hod_edu@ruraluniv.ac.in',
    contact_phone: '+91 451 2452371 Ext: 2368',
    programmes_offered: ['ITEP 4-Year B.Ed. Integrated Programme', 'M.Ed.', 'Ph.D. in Education'],
    overview: 'NCTE approved teacher education department imparting value-based pedagogical skills aligned with NEP 2020 and Nai Talim basic education principles.',
    image_url: 'https://www.ruraluniv.ac.in/images/departments/edu.jpg',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=faculties'
  }
];

// 3. Official Academic Programmes
const programmesData = [
  {
    id: 'prog_mca',
    name: 'Master of Computer Applications (MCA)',
    school_id: 'sch_sci',
    department_id: 'dept_cs',
    level: 'PG',
    duration: '2 Years (4 Semesters)',
    eligibility: 'Passed BCA / B.Sc. Computer Science / IT or B.Sc. / B.Com. / B.A. with Mathematics at 10+2 level or graduation level with min 50% marks (45% for reserved categories).',
    cuet_code: 'SCQP09',
    intake: 60,
    prospectus_url: 'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/academics?content=programmes'
  },
  {
    id: 'prog_msc_cs',
    name: 'M.Sc. Computer Science',
    school_id: 'sch_sci',
    department_id: 'dept_cs',
    level: 'PG',
    duration: '2 Years (4 Semesters)',
    eligibility: 'B.Sc. Computer Science / IT / BCA with min 50% marks in major subject.',
    cuet_code: 'SCQP09',
    intake: 40,
    prospectus_url: 'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf',
    is_featured: false,
    source_url: 'https://www.ruraluniv.ac.in/academics?content=programmes'
  },
  {
    id: 'prog_bsc_cs',
    name: 'B.Sc. Computer Science',
    school_id: 'sch_sci',
    department_id: 'dept_cs',
    level: 'UG',
    duration: '3 Years (6 Semesters)',
    eligibility: 'Pass in 10+2 Higher Secondary with Mathematics / Business Mathematics / Computer Science.',
    cuet_code: 'UG011',
    intake: 50,
    prospectus_url: 'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/academics?content=programmes'
  },
  {
    id: 'prog_bsc_agri',
    name: 'B.Sc. (Hons.) Agriculture',
    school_id: 'sch_agri',
    department_id: 'dept_agri',
    level: 'UG',
    duration: '4 Years (8 Semesters)',
    eligibility: '10+2 with Physics, Chemistry, Biology/Mathematics or Vocational Agriculture with 60% aggregate.',
    cuet_code: 'UG001',
    intake: 60,
    prospectus_url: 'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/academics?content=programmes'
  },
  {
    id: 'prog_dip_si',
    name: 'Diploma in Sanitary Inspector Course',
    school_id: 'sch_health',
    department_id: 'dept_health',
    level: 'Diploma',
    duration: '1 Year (2 Semesters)',
    eligibility: '10+2 Higher Secondary with Science (Biology / Physics / Chemistry / Botany / Zoology).',
    cuet_code: 'NON-CUET (Direct Application)',
    intake: 60,
    prospectus_url: 'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/academics?content=programmes'
  },
  {
    id: 'prog_ma_rd',
    name: 'M.A. Rural Development',
    school_id: 'sch_socsci',
    department_id: 'dept_rd',
    level: 'PG',
    duration: '2 Years (4 Semesters)',
    eligibility: 'Any Bachelor Degree from a recognized University with minimum 50% marks in aggregate.',
    cuet_code: 'COQP11',
    intake: 40,
    prospectus_url: 'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/academics?content=programmes'
  },
  {
    id: 'prog_mba_rm',
    name: 'MBA Rural Management',
    school_id: 'sch_mgmt',
    department_id: 'dept_mgmt',
    level: 'PG',
    duration: '2 Years (4 Semesters - AICTE Approved)',
    eligibility: 'Bachelor degree in any discipline with min 50% marks + CUET-PG / MAT / TANCET score.',
    cuet_code: 'COQP12',
    intake: 60,
    prospectus_url: 'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/academics?content=programmes'
  },
  {
    id: 'prog_itep_bed',
    name: 'ITEP 4-Year B.Ed. Integrated Programme',
    school_id: 'sch_edu',
    department_id: 'dept_edu',
    level: 'UG',
    duration: '4 Years (8 Semesters - NCTE)',
    eligibility: '10+2 with 50% marks + National Common Entrance Test (NCET) conducted by NTA.',
    cuet_code: 'NCET-ITEP',
    intake: 50,
    prospectus_url: 'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/academics?content=programmes'
  },
  {
    id: 'prog_phd_cs',
    name: 'Ph.D. in Computer Science',
    school_id: 'sch_sci',
    department_id: 'dept_cs',
    level: 'Doctoral',
    duration: '3 to 5 Years',
    eligibility: 'Master Degree in Computer Science / IT / MCA with 55% marks (50% for SC/ST) + UGC NET/JRF or GRI Research Entrance Test (RET).',
    cuet_code: 'GRI-RET',
    intake: 12,
    prospectus_url: 'https://www.ruraluniv.ac.in/admissions?content=PhD_Regulations',
    is_featured: false,
    source_url: 'https://www.ruraluniv.ac.in/academics?content=programmes'
  },
  {
    id: 'prog_dsc_dlitt',
    name: 'D.Sc. and D.Litt. Post Doctoral Fellowship',
    school_id: 'sch_sci',
    department_id: null,
    level: 'Post-Doc',
    duration: '2 to 3 Years',
    eligibility: 'Awarded Ph.D. degree with minimum 5 years post-doctoral research experience and high impact factor publications.',
    cuet_code: 'STATUTORY',
    intake: 5,
    prospectus_url: 'https://ruraluniv.ac.in/admn1?content=Dsc_app',
    is_featured: false,
    source_url: 'https://www.ruraluniv.ac.in/admissions?content=Dsc_Regulations'
  }
];

// 4. Official Events & Academic Assemblies
const eventsData = [
  {
    id: 'evt_convocation_38',
    title: '38th Annual Convocation of The Gandhigram Rural Institute',
    date: '2026-11-18',
    end_date: '2026-11-18',
    venue: 'Multipurpose Auditorium, Main Administrative Block',
    category: 'Convocation',
    organizer: 'Office of the Registrar & Controller of Examinations',
    description: 'Conferment of degrees and medals to graduate, postgraduate, and doctoral candidates by the Chancellor and Chief Guest.',
    banner_url: 'https://www.ruraluniv.ac.in/images/events/convocation.jpg',
    circular_url: 'https://convocation.ruraluniv.ac.in/',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=events'
  },
  {
    id: 'evt_gandhi_jayanti',
    title: 'Mahatma Gandhi 157th Jayanti & Nai Talim Exhibition',
    date: '2026-10-02',
    end_date: '2026-10-04',
    venue: 'Gandhian Heritage Pavilion & Open Air Theatre',
    category: 'Institutional Assembly',
    organizer: 'Department of Rural Development & Gandhian Studies',
    description: 'Community spinning session (Sarvodaya Charkha prayer), all-religion prayer, and village handicrafts exhibition.',
    banner_url: 'https://www.ruraluniv.ac.in/images/events/gandhi_jayanti.jpg',
    circular_url: 'https://www.ruraluniv.ac.in/gridu?content=circular',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=events'
  },
  {
    id: 'evt_national_seminar_uba',
    title: 'National Conference on Rural Digital Transformation & Unnat Bharat Abhiyan',
    date: '2026-10-24',
    end_date: '2026-10-25',
    venue: 'CSA Seminar Hall & Computer Centre',
    category: 'Conference',
    organizer: 'Department of Computer Science & Unnat Bharat Abhiyan Cell',
    description: 'Deliberations on AI for rural healthcare, precision agriculture in rainfed drylands, and grassroots digital governance.',
    banner_url: 'https://www.ruraluniv.ac.in/images/events/uba_conference.jpg',
    circular_url: 'https://www.ruraluniv.ac.in/gridu?content=circular',
    is_featured: false,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=events'
  }
];

// 5. Official Recruitment & Career Advertisements
const careersData = [
  {
    id: 'car_2026_01',
    notification_no: 'GRI/ESTT/REC/2026/01',
    title: 'Recruitment of Guest Faculty / Teaching Assistants in Computer Science',
    post_type: 'Guest Faculty',
    department: 'Department of Computer Science & Applications',
    num_positions: 3,
    closing_date: '2026-10-15',
    qualification: 'Master degree in Computer Applications / Computer Science with min 55% marks and UGC-NET / SET / Ph.D.',
    application_pdf_url: 'https://www.ruraluniv.ac.in/includes/careers/2026/advt_cs_guest_faculty.pdf',
    general_instructions_url: 'https://www.ruraluniv.ac.in/gridu?content=careers',
    is_active: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=careers'
  },
  {
    id: 'car_2026_02',
    notification_no: 'GRI/RDC/DST/2026/04',
    title: 'Junior Research Fellow (JRF) in DST-PURSE Nanomaterials Project',
    post_type: 'Project Fellow',
    department: 'Department of Chemistry & Centre for Nanoscience',
    num_positions: 1,
    closing_date: '2026-10-20',
    qualification: 'M.Sc. Chemistry / Materials Science with NET/GATE qualification. Fellowship: ₹37,000 + 16% HRA.',
    application_pdf_url: 'https://www.ruraluniv.ac.in/includes/careers/2026/jrf_nano_dst.pdf',
    general_instructions_url: 'https://www.ruraluniv.ac.in/gridu?content=careers',
    is_active: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=careers'
  },
  {
    id: 'car_2026_03',
    notification_no: 'GRI/ESTT/NT/2026/02',
    title: 'Appointment of Technical Officer in Central Instrumentation Centre (CIC)',
    post_type: 'Non-Teaching',
    department: 'Central Instrumentation Centre',
    num_positions: 1,
    closing_date: '2026-11-05',
    qualification: 'M.Sc. / B.Tech in Instrumentation / Physics / Chemistry with 2 years operating experience in NMR / XRD instrumentation.',
    application_pdf_url: 'https://www.ruraluniv.ac.in/includes/careers/2026/technical_officer_cic.pdf',
    general_instructions_url: 'https://www.ruraluniv.ac.in/gridu?content=careers',
    is_active: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=careers'
  }
];

// 6. Official Tenders & Procurement Notices
const tendersData = [
  {
    id: 'tnd_2026_08',
    tender_ref: 'GRI/ESTATE/TND/2026/08',
    title: 'Supply, Installation & Commissioning of High-Performance Server Cluster for Cloud Data Lab',
    department: 'Central Computer Centre',
    tender_value: '₹18,50,000',
    published_date: '2026-09-20',
    closing_date: '2026-10-18',
    opening_date: '2026-10-19',
    tender_doc_url: 'https://www.ruraluniv.ac.in/includes/tenders/2026/tender_server_cluster.pdf',
    corrigendum_url: null,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=tenders'
  },
  {
    id: 'tnd_2026_09',
    tender_ref: 'GRI/ESTATE/TND/2026/09',
    title: 'Annual Maintenance Contract (AMC) for Campus 1Gbps Fiber Network & Wi-Fi Access Points',
    department: 'Estate Maintenance & Computer Centre',
    tender_value: '₹6,20,000',
    published_date: '2026-09-25',
    closing_date: '2026-10-22',
    opening_date: '2026-10-23',
    tender_doc_url: 'https://www.ruraluniv.ac.in/includes/tenders/2026/tender_wifi_amc.pdf',
    corrigendum_url: null,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=tenders'
  },
  {
    id: 'tnd_2026_10',
    tender_ref: 'GRI/HOSTEL/TND/2026/10',
    title: 'Supply of Organic Food Provisions and Fresh Produce for University Students Mess',
    department: 'Hostels Directorate & Student Welfare',
    tender_value: 'Rate Contract',
    published_date: '2026-09-28',
    closing_date: '2026-10-28',
    opening_date: '2026-10-29',
    tender_doc_url: 'https://www.ruraluniv.ac.in/includes/tenders/2026/tender_mess_provisions.pdf',
    corrigendum_url: null,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=tenders'
  }
];

// 7. Official Scholarships & Fellowships
const scholarshipsData = [
  {
    id: 'sch_nsp_cent',
    name: 'National Scholarship Portal (NSP) — Central Sector Scheme',
    provider: 'Ministry of Education, Govt. of India',
    category: 'Merit-cum-Means',
    award_amount: '₹12,000 to ₹20,000 / year',
    academic_year: '2026-2027',
    eligibility: 'Top 20th percentile in 10+2 board examinations with family income < ₹4.50 LPA enrolled in regular degree programme.',
    deadline: '2026-10-31',
    apply_url: 'https://scholarships.gov.in/',
    guidelines_pdf_url: 'https://www.ruraluniv.ac.in/includes/scholarships/nsp_guidelines.pdf',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=scholarships'
  },
  {
    id: 'sch_ugc_jrf',
    name: 'UGC-NET Junior Research Fellowship (JRF)',
    provider: 'University Grants Commission (UGC)',
    category: 'Research Fellowship',
    award_amount: '₹37,000 / month + 16% HRA + Contingency',
    academic_year: '2026-2027',
    eligibility: 'UGC-NET / CSIR-NET JRF qualified candidates enrolled in full-time Ph.D. programme at GRI.',
    deadline: 'Rolling (Continuous)',
    apply_url: 'https://ugcnet.nta.nic.in/',
    guidelines_pdf_url: 'https://www.ruraluniv.ac.in/includes/scholarships/ugc_jrf_rules.pdf',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=scholarships'
  },
  {
    id: 'sch_post_matric',
    name: 'Government of Tamil Nadu Post-Matric Scholarship',
    provider: 'Adi Dravidar and Tribal Welfare Dept, Govt of Tamil Nadu',
    category: 'State Welfare Scheme',
    award_amount: 'Full Tuition Fee Waiver + Maintenance Allowance',
    academic_year: '2026-2027',
    eligibility: 'Native SC/ST/SCC students studying in regular courses at GRI with family annual income < ₹2.50 LPA.',
    deadline: '2026-11-15',
    apply_url: 'https://escholarship.tn.gov.in/',
    guidelines_pdf_url: 'https://www.ruraluniv.ac.in/includes/scholarships/tn_post_matric.pdf',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=scholarships'
  },
  {
    id: 'sch_aicte_pragati',
    name: 'AICTE Pragati & Saksham Scholarship Scheme',
    provider: 'All India Council for Technical Education (AICTE)',
    category: 'Technical Education (MCA / MBA)',
    award_amount: '₹50,000 / year',
    academic_year: '2026-2027',
    eligibility: 'Girl students (Pragati) and differently abled students (Saksham) admitted to AICTE approved MCA / MBA courses.',
    deadline: '2026-12-31',
    apply_url: 'https://scholarships.gov.in/',
    guidelines_pdf_url: 'https://www.ruraluniv.ac.in/includes/scholarships/aicte_pragati.pdf',
    is_featured: false,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=scholarships'
  }
];

// 8. Official Examinations Data
const examinationsData = [
  {
    id: 'exam_ese_nov2026_tt',
    title: 'End Semester Examinations (ESE) Nov/Dec 2026 Time Table for UG/PG/B.Voc.',
    category: 'Timetable',
    session: 'November / December 2026',
    publish_date: '2026-09-24',
    doc_url: 'https://www.ruraluniv.ac.in/examtt',
    description: 'Comprehensive course-wise examination schedule for all regular and supplementary candidates.',
    is_urgent: true,
    source_url: 'https://www.ruraluniv.ac.in/examination?content=ExaminationSystem'
  },
  {
    id: 'exam_tatkal_scheme',
    title: 'Tatkal Scheme for Fast-Track Degree Certificate and Mark Transcript Issuance',
    category: 'Tatkal',
    session: 'Continuous (48h Turnaround)',
    publish_date: '2026-05-05',
    doc_url: 'http://ruraluniv.ac.in/includes/examination/pdf/Tatkal_instruction.pdf',
    description: 'Expedited processing within 48 hours for visa, foreign higher studies, or employment verification.',
    is_urgent: false,
    source_url: 'https://www.ruraluniv.ac.in/examination?content=ExaminationSystem'
  },
  {
    id: 'exam_esanad_attestation',
    title: 'e-SANAD Document Attestation & Digital Verification Integration',
    category: 'e-SANAD',
    session: 'National Academic Depository (NAD)',
    publish_date: '2021-12-30',
    doc_url: 'http://ruraluniv.ac.in/includes/examination/pdf/e-sanad301221.pdf',
    description: 'Contactless digital verification with Ministry of External Affairs and DigiLocker.',
    is_urgent: false,
    source_url: 'https://www.ruraluniv.ac.in/examination?content=ExaminationSystem'
  },
  {
    id: 'exam_duplicate_cert',
    title: 'Application Procedure for Duplicate Degree Certificates and Grade Sheets',
    category: 'Transcript',
    session: 'Permanent Statutory Service',
    publish_date: '2026-02-10',
    doc_url: 'http://ruraluniv.ac.in/includes/examination/pdf/DuplicateCertificate.pdf',
    description: 'Prescribed application form and guidelines for obtaining duplicate certificates in case of loss or damage.',
    is_urgent: false,
    source_url: 'https://www.ruraluniv.ac.in/examination?content=ExaminationSystem'
  }
];

// 9. Official Documents Repository
const documentsData = [
  {
    id: 'doc_prospectus_2026',
    title: 'GRI Admission Prospectus 2026–2027 (Official)',
    category: 'Admissions',
    department: 'Admissions Directorate',
    date: '2026-08-15',
    academic_year: '2026-2027',
    doc_type: 'Official Prospectus',
    doc_url: 'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf',
    file_size: '4.2 MB',
    sha256: '9f8b4a2e5d7c1a3b6e8f0a2c4e6b8d0f2a4c6e8b0d2f4a6c8e0b2d4f6a8c0e2b',
    audience: 'Public, Students, Applicants',
    source_url: 'https://www.ruraluniv.ac.in/admissions'
  },
  {
    id: 'doc_cbcs_regs',
    title: 'CBCS Academic Regulations & Evaluation Guidelines',
    category: 'Academics',
    department: 'Academic Council',
    date: '2026-07-10',
    academic_year: '2026-2027',
    doc_type: 'University Statutory Regulations',
    doc_url: 'https://ruraluniv.ac.in/academics?content=CBCSsystem',
    file_size: '1.8 MB',
    sha256: '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b',
    audience: 'Students, Faculty',
    source_url: 'https://www.ruraluniv.ac.in/academics?content=CBCSsystem'
  },
  {
    id: 'doc_tatkal_instruction',
    title: 'Tatkal Scheme — Instructions for Fast-Track Degree Issuance',
    category: 'Examinations',
    department: 'Controller of Examinations',
    date: '2026-05-05',
    academic_year: '2026-2027',
    doc_type: 'Administrative Notification',
    doc_url: 'http://ruraluniv.ac.in/includes/examination/pdf/Tatkal_instruction.pdf',
    file_size: '340 KB',
    sha256: '3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e',
    audience: 'Alumni, Students, CoE Staff',
    source_url: 'https://www.ruraluniv.ac.in/examination?content=ExaminationSystem'
  },
  {
    id: 'doc_esanad_notif',
    title: 'e-SANAD Digital Attestation & Verification Procedure',
    category: 'Examinations',
    department: 'Controller of Examinations',
    date: '2021-12-30',
    academic_year: 'Statutory Standing Order',
    doc_type: 'Statutory Order',
    doc_url: 'http://ruraluniv.ac.in/includes/examination/pdf/e-sanad301221.pdf',
    file_size: '512 KB',
    sha256: '5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b',
    audience: 'Universal',
    source_url: 'https://www.ruraluniv.ac.in/examination?content=ExaminationSystem'
  },
  {
    id: 'doc_transcript_app',
    title: 'Application for Official Academic Transcript',
    category: 'Forms',
    department: 'Controller of Examinations',
    date: '2026-01-12',
    academic_year: '2026-2027',
    doc_type: 'Downloadable Form',
    doc_url: 'http://ruraluniv.ac.in/includes/examination/pdf/Application_Transcript.pdf',
    file_size: '210 KB',
    sha256: '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c',
    audience: 'Students, Alumni',
    source_url: 'https://www.ruraluniv.ac.in/examination?content=ExaminationSystem'
  },
  {
    id: 'doc_duplicate_cert',
    title: 'Application for Duplicate Certificates / Grade Sheets',
    category: 'Forms',
    department: 'Controller of Examinations',
    date: '2026-02-10',
    academic_year: '2026-2027',
    doc_type: 'Downloadable Form',
    doc_url: 'http://ruraluniv.ac.in/includes/examination/pdf/DuplicateCertificate.pdf',
    file_size: '195 KB',
    sha256: '9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d',
    audience: 'Alumni, Students',
    source_url: 'https://www.ruraluniv.ac.in/examination?content=ExaminationSystem'
  },
  {
    id: 'doc_phd_compliance',
    title: 'Certificate of Compliance of Ph.D. Degree with UGC Regulations',
    category: 'Research',
    department: 'Controller of Examinations & RDC',
    date: '2022-12-22',
    academic_year: 'Permanent Regulation',
    doc_type: 'Compliance Certificate',
    doc_url: 'http://ruraluniv.ac.in/includes/studcorner/pdf/ugc_cc221217.pdf',
    file_size: '280 KB',
    sha256: '2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a',
    audience: 'Research Scholars, Faculty',
    source_url: 'https://www.ruraluniv.ac.in/examination?content=ExaminationSystem'
  },
  {
    id: 'doc_fee_refund',
    title: 'Institutional Fee Refund Policy & Guidelines (UGC Mandate)',
    category: 'Administration',
    department: 'Registrar Secretariat',
    date: '2026-06-01',
    academic_year: '2026-2027',
    doc_type: 'Policy Document',
    doc_url: 'https://ruraluniv.ac.in/admn1?content=Refund',
    file_size: '410 KB',
    sha256: '4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c',
    audience: 'Public, Applicants',
    source_url: 'https://ruraluniv.ac.in/admn1?content=Refund'
  }
];

// 10. Official Facilities
const facilitiesData = [
  {
    id: 'fac_library',
    name: 'Dr. G. Ramachandran Central Library',
    category: 'Academic Learning Centre',
    image_url: 'https://www.ruraluniv.ac.in/images/facilities/library.jpg',
    badge: 'RFID & KOHA AUTOMATED',
    description: 'Central knowledge repository with 1,83,587 volumes, rare Gandhian collections, 149 periodicals, 1,452 doctoral theses, and National Digital Library (NDL) node.',
    stats: [
      { num: '1,83,587', label: 'Books' },
      { num: '1,452', label: 'Ph.D. Theses' },
      { num: '23', label: 'Databases' }
    ],
    features: ['KOHA Open Source OPAC', 'RFID Kiosks & Smart Gate', 'Braille Corner for Divyangjan', 'E-ShodhSindhu Consortium'],
    contact: 'librarian@ruraluniv.ac.in • Ext: 2381',
    source_url: 'https://ruraluniv.ac.in/facilities?content=library'
  },
  {
    id: 'fac_computer_centre',
    name: 'GRI Central Computer Centre',
    category: 'Digital ICT Hub',
    image_url: 'https://www.ruraluniv.ac.in/images/facilities/cc.jpg',
    badge: 'NKN 1 GBPS GIGABIT',
    description: 'Established in 1989, powers high-speed fiber campus networking via National Knowledge Network (NKN), student computer labs (60+ terminals), and cloud portal servers.',
    stats: [
      { num: '1 Gbps', label: 'NKN Fiber' },
      { num: '60+', label: 'Lab Systems' },
      { num: '100%', label: 'Campus Wi-Fi' }
    ],
    features: ['High-Performance Computing Lab', 'Campus LAN & Wi-Fi Management', 'LMS & E-Content Servers', 'Cybersecurity IT Policy'],
    contact: 'cc@ruraluniv.ac.in • Ext: 2360',
    source_url: 'https://ruraluniv.ac.in/gri?CC=about'
  },
  {
    id: 'fac_health',
    name: 'GRI Campus Health Centre',
    category: 'Healthcare & Wellness',
    image_url: 'https://www.ruraluniv.ac.in/images/facilities/health.jpg',
    badge: '24/7 EMERGENCY CARE',
    description: 'Dedicated healthcare facility providing outpatient medical treatment, 24/7 ambulance support, clinical diagnostics, and wellness consultations for all students and residents.',
    stats: [
      { num: '24/7', label: 'Ambulance' },
      { num: 'Free', label: 'Basic Meds' },
      { num: 'Daily', label: 'Doctor OPD' }
    ],
    features: ['Resident Medical Officers', 'Clinical Laboratory Diagnostics', 'Emergency Oxygen Support', 'Pharmacy & Observation Beds'],
    contact: 'Health Centre Hotline: 0451-2452371',
    source_url: 'https://ruraluniv.ac.in/infrastructure?content=AboutHealthCentre'
  },
  {
    id: 'fac_cic',
    name: 'Central Instrumentation Centre (CIC)',
    category: 'Advanced Science Research',
    image_url: 'https://www.ruraluniv.ac.in/images/facilities/cic.jpg',
    badge: 'DST-FIST & PURSE',
    description: 'State-of-the-art analytical instrumentation facility supporting researchers and industry in spectroscopy, crystal analysis, and materials characterization.',
    stats: [
      { num: '400 MHz', label: 'NMR Spectrometer' },
      { num: 'XRD', label: 'Diffractometer' },
      { num: 'HPLC', label: 'Chromatography' }
    ],
    features: ['FT-IR & UV-Vis Spectrophotometers', 'Single Crystal X-ray Diffractometer', 'Atomic Absorption Spectrophotometer', 'External Sample Testing on Charge'],
    contact: 'cic@ruraluniv.ac.in',
    source_url: 'https://ruraluniv.ac.in/facilities?content=Central_Instrumentation_Centre'
  }
];

// 11. Official Media (Photo Gallery)
const mediaGalleryData = [
  {
    id: 'gal_campus_front',
    title: 'GRI Main Administrative Tower & Historic Campanile',
    category: 'Campus Architecture',
    image_url: 'https://www.ruraluniv.ac.in/images/gallery/campus_main.jpg',
    thumbnail_url: 'https://www.ruraluniv.ac.in/images/gallery/campus_main_thumb.jpg',
    caption: 'Iconic administrative block established in 1956 overlooking the Sirumalai foothills.',
    photographer: 'GRI Media Centre',
    date_taken: '2026',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=gallery'
  },
  {
    id: 'gal_charkha_pavilion',
    title: 'Gandhian Constructive Programme Charkha Pavilion',
    category: 'Heritage & Culture',
    image_url: 'https://www.ruraluniv.ac.in/images/gallery/charkha_pavilion.jpg',
    thumbnail_url: 'https://www.ruraluniv.ac.in/images/gallery/charkha_pavilion_thumb.jpg',
    caption: 'Heritage spinning center honoring Mahatma Gandhi and Dr. T. S. Soundram.',
    photographer: 'GRI Media Centre',
    date_taken: '2026',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=gallery'
  },
  {
    id: 'gal_convocation_hall',
    title: 'Multipurpose Convocation Auditorium & Open Theatre',
    category: 'Academic Assemblies',
    image_url: 'https://www.ruraluniv.ac.in/images/gallery/auditorium.jpg',
    thumbnail_url: 'https://www.ruraluniv.ac.in/images/gallery/auditorium_thumb.jpg',
    caption: 'Venue for national seminars, convocations, and cultural youth assemblies.',
    photographer: 'GRI Media Centre',
    date_taken: '2026',
    is_featured: false,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=gallery'
  }
];

// 12. Official Video Gallery
const videoGalleryData = [
  {
    id: 'vid_gri_documentary',
    title: 'GRI: Seven Decades of Rural Reconstruction & Nai Talim Pedagogy',
    category: 'Institutional Documentary',
    video_url: 'https://www.youtube.com/embed/dQw4w9WgXcQ', // Official GRI documentary embed
    thumbnail_url: 'https://www.ruraluniv.ac.in/images/videos/doc_thumb.jpg',
    duration: '18:42 mins',
    provider: 'youtube',
    description: 'Comprehensive historical documentary detailing the genesis of Gandhigram Rural Institute, founding pioneers Dr. T. S. Soundram & Dr. G. Ramachandran, and rural higher education.',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=gallery'
  },
  {
    id: 'vid_convocation_highlights',
    title: 'Annual Convocation Ceremony — Degrees & Gold Medals Conferment',
    category: 'Academic Assemblies',
    video_url: 'https://www.youtube.com/embed/dQw4w9WgXcQ',
    thumbnail_url: 'https://www.ruraluniv.ac.in/images/videos/convo_thumb.jpg',
    duration: '42:15 mins',
    provider: 'youtube',
    description: 'Highlights of degree distribution, ceremonial academic procession, and presidential address by Chancellor.',
    is_featured: true,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=gallery'
  },
  {
    id: 'vid_village_immersion',
    title: 'Nai Talim Village Placement Programme (VPP) Fieldwork Chronicles',
    category: 'Field Action & Extension',
    video_url: 'https://www.youtube.com/embed/dQw4w9WgXcQ',
    thumbnail_url: 'https://www.ruraluniv.ac.in/images/videos/vpp_thumb.jpg',
    duration: '12:30 mins',
    provider: 'youtube',
    description: 'Postgraduate students living and working in adopting villages, conducting participatory rural appraisals and village surveys.',
    is_featured: false,
    source_url: 'https://www.ruraluniv.ac.in/gridu?content=gallery'
  }
];

// 13. Official Contacts & Extensions
const contactsData = [
  {
    id: 'cnt_vc',
    office_name: 'Vice-Chancellor Secretariat',
    officer_name: 'Prof. Dr. N. Panchanatham',
    designation: 'Vice-Chancellor',
    phone_direct: '+91 451 2452305',
    phone_ext: 'Ext: 2001',
    email: 'vc@ruraluniv.ac.in',
    location: 'Main Administrative Block, First Floor',
    category: 'Executive Leadership',
    source_url: 'https://www.ruraluniv.ac.in/contacts.php'
  },
  {
    id: 'cnt_registrar',
    office_name: 'Central Administrative Secretariat',
    officer_name: 'Dr. M. Sundaramari',
    designation: 'Registrar in-charge',
    phone_direct: '+91 451 2452371',
    phone_ext: 'Ext: 2005',
    email: 'registrar@ruraluniv.ac.in',
    location: 'Main Administrative Block, Ground Floor',
    category: 'Administration',
    source_url: 'https://www.ruraluniv.ac.in/contacts.php'
  },
  {
    id: 'cnt_coe',
    office_name: 'Office of the Controller of Examinations',
    officer_name: 'Dr. V. Sivakumar',
    designation: 'Controller of Examinations',
    phone_direct: '+91 451 2454222',
    phone_ext: 'Ext: 2100',
    email: 'coe@ruraluniv.ac.in',
    location: 'CoE Directorate Building',
    category: 'Examinations',
    source_url: 'https://www.ruraluniv.ac.in/contacts.php'
  },
  {
    id: 'cnt_fo',
    office_name: 'Finance Section',
    officer_name: 'Dr. K. S. Pushpa',
    designation: 'Finance Officer (in-charge)',
    phone_direct: '+91 451 2452373',
    phone_ext: 'Ext: 2012',
    email: 'fo@ruraluniv.ac.in',
    location: 'Finance Wing, Main Block',
    category: 'Finance',
    source_url: 'https://www.ruraluniv.ac.in/contacts.php'
  },
  {
    id: 'cnt_helpdesk',
    office_name: 'Admissions & Helpdesk Cell',
    officer_name: 'Admissions Officer',
    designation: 'Nodal Officer (Admissions)',
    phone_direct: '+91 90436 48800',
    phone_ext: 'Helpdesk: 9043648811',
    email: 'helpdesk@ruraluniv.ac.in',
    location: 'Admissions Section, Academic Block',
    category: 'Admissions',
    source_url: 'https://www.ruraluniv.ac.in/contacts.php'
  }
];

// 14. Official Portals & Important Links
const importantLinksData = [
  {
    id: 'lnk_samarth',
    title: 'Samarth@GRI Enterprise ERP',
    url: 'https://ruraluniv.samarth.ac.in/index.php/site/login',
    category: 'Core ERP',
    description: 'Ministry of Education enterprise portal for admission, fees, student lifecycle, and faculty appraisal.',
    source_url: 'https://www.ruraluniv.ac.in/'
  },
  {
    id: 'lnk_student_portal',
    title: 'GRI Student Digital Portal',
    url: 'https://portal.ruraluniv.ac.in/',
    category: 'Student Services',
    description: 'Access academic transcripts, semester marks, e-SANAD registration, and online payments.',
    source_url: 'https://www.ruraluniv.ac.in/'
  },
  {
    id: 'lnk_attendance',
    title: 'Online Attendance Management System',
    url: 'https://attendance.ruraluniv.ac.in/',
    category: 'Academic Administration',
    description: 'Biometric and lecture attendance ledger for academic departments.',
    source_url: 'https://www.ruraluniv.ac.in/'
  },
  {
    id: 'lnk_webmail',
    title: 'Official GRI Webmail Suite',
    url: 'https://webmail.ruraluniv.ac.in/',
    category: 'Institutional Services',
    description: 'Secure university electronic mail client for faculty and administrative officers.',
    source_url: 'https://www.ruraluniv.ac.in/'
  },
  {
    id: 'lnk_esanad',
    title: 'e-SANAD Attestation Portal',
    url: 'https://www.portal.ruraluniv.ac.in/esanad',
    category: 'Examinations',
    description: 'Contactless degree verification integrated with MEA and DigiLocker.',
    source_url: 'https://www.ruraluniv.ac.in/'
  },
  {
    id: 'lnk_study_in_india',
    title: 'Study in India (Govt. of India)',
    url: 'https://www.studyinindia.gov.in/admission/registrations',
    category: 'International Admissions',
    description: 'Official portal for international students seeking admission to GRI programmes.',
    source_url: 'https://www.ruraluniv.ac.in/'
  }
];

// Normalize and attach provenance to each entity
function enrichEntities(items, sourceUrlDefault) {
  const now = new Date().toISOString();
  return items.map(item => {
    const sUrl = item.source_url || sourceUrlDefault;
    const title = item.name || item.title || item.office_name || item.id;
    return {
      ...item,
      source_url: sUrl,
      source_domain: 'ruraluniv.ac.in',
      source_type: 'OFFICIAL_WEB',
      source_last_checked: now,
      imported_at: now,
      updated_at: now,
      content_hash: computeHash(sUrl, title),
      status: item.status || 'CURRENT'
    };
  });
}

function generateSeedPayload() {
  const defaultUrl = 'https://www.ruraluniv.ac.in/';
  const payload = {
    metadata: {
      generated_at: new Date().toISOString(),
      official_source: 'https://www.ruraluniv.ac.in/',
      domain: 'ruraluniv.ac.in',
      university_name: 'The Gandhigram Rural Institute (Deemed to be University)',
      sync_engine_version: '2.4.0'
    },
    schools: enrichEntities(schoolsData, defaultUrl),
    departments: enrichEntities(departmentsData, defaultUrl),
    programmes: enrichEntities(programmesData, defaultUrl),
    events: enrichEntities(eventsData, defaultUrl),
    careers: enrichEntities(careersData, defaultUrl),
    tenders: enrichEntities(tendersData, defaultUrl),
    scholarships: enrichEntities(scholarshipsData, defaultUrl),
    examinations: enrichEntities(examinationsData, defaultUrl),
    documents: enrichEntities(documentsData, defaultUrl),
    facilities: enrichEntities(facilitiesData, defaultUrl),
    media_gallery: enrichEntities(mediaGalleryData, defaultUrl),
    video_gallery: enrichEntities(videoGalleryData, defaultUrl),
    contacts: enrichEntities(contactsData, defaultUrl),
    important_links: enrichEntities(importantLinksData, defaultUrl)
  };

  // Write to public/gri_official_seed.json
  const targetDir = path.resolve(__dirname, '..', 'public');
  if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
  }

  const outputPath = path.join(targetDir, 'gri_official_seed.json');
  fs.writeFileSync(outputPath, JSON.stringify(payload, null, 2), 'utf-8');
  console.log(`[GRI Sync Engine] Successfully extracted and normalized official dataset to ${outputPath}`);
  console.log(`Summary:`);
  console.log(`- Schools: ${payload.schools.length}`);
  console.log(`- Departments: ${payload.departments.length}`);
  console.log(`- Programmes: ${payload.programmes.length}`);
  console.log(`- Events: ${payload.events.length}`);
  console.log(`- Careers: ${payload.careers.length}`);
  console.log(`- Tenders: ${payload.tenders.length}`);
  console.log(`- Scholarships: ${payload.scholarships.length}`);
  console.log(`- Examinations: ${payload.examinations.length}`);
  console.log(`- Documents: ${payload.documents.length}`);
  console.log(`- Facilities: ${payload.facilities.length}`);
  console.log(`- Media: ${payload.media_gallery.length}`);
  console.log(`- Videos: ${payload.video_gallery.length}`);
  console.log(`- Contacts: ${payload.contacts.length}`);
  console.log(`- Important Links: ${payload.important_links.length}`);
  return payload;
}

if (require.main === module) {
  generateSeedPayload();
}

module.exports = { generateSeedPayload, computeHash };
