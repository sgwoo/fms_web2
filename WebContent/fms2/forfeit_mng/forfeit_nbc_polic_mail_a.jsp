<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.admin.*,  acar.client.*,  acar.res_search.*,  acar.im_email.*, tax.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	

//	String email 	= request.getParameter("email")==null?"":request.getParameter("email");
	
	int flag1 = 0;

	int result = 0;
	
	//과태료정보
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");		
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String res_firm = request.getParameter("res_firm")==null?"":request.getParameter("res_firm");
	
	String dem_dt = request.getParameter("dem_dt")==null?"":request.getParameter("dem_dt");
	String e_dem_dt = request.getParameter("e_dem_dt")==null?"":request.getParameter("e_dem_dt");
	
	
	String[] chk_cd = request.getParameterValues("ch_l_cd");

	String vid_num="";
	
	String ch_m_id="";  
	String ch_l_cd="";
	String ch_c_id="";
	String ch_seq_no="";
	String ch_cust_nm="";		
	String ch_dem_dt="";		
	String ch_e_dem_dt="";		
	String ch_gubun="";
		
	String subject 		= "";
	String msg 			= "";
	String sendname 	= "(주)아마존카";
	String sendphone 	= "02-392-4242";
	String email 		= "";
	int seqidx			= 0;	
	String gov_nm = "";	
	
	
	String ck_m_id1 = "";
	String ck_m_id2 = "";
	String ck_m_id3 = "";
	
	
	for(int i=0; i<chk_cd.length;i++){
		vid_num=chk_cd[i];
		
	//System.out.println("vid_num="+vid_num);
			
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
				ch_m_id = token1.nextToken().trim();	 
				ch_l_cd = token1.nextToken().trim();	 
				ch_c_id = token1.nextToken().trim();	 
				ch_seq_no = token1.nextToken().trim();	
				ch_cust_nm = token1.nextToken().trim();	//임원급이상
				ch_dem_dt = token1.nextToken().trim();	//선납과태료 청구일
				ch_e_dem_dt = token1.nextToken().trim(); //선납과태료 청구서 발행일
		}
	
	if(ch_e_dem_dt.equals("")||ch_e_dem_dt.equals("null")){
			ch_e_dem_dt = AddUtil.getDate();
		}
		
		ck_m_id1 = ch_m_id ;
		
		if(ck_m_id2 == ck_m_id1){  //중복체크- 같으면 패스
		
		//System.out.println("ck_m_id1="+ck_m_id1);
		//System.out.println("ck_m_id2="+ck_m_id2);
		
		}else{//중복체크 - 다르면 아래코드 실행.
			ck_m_id2 = ck_m_id1;
		
	
	
	

	//cont_view
		Hashtable base = ad_db.getContEmail(ch_m_id, ch_l_cd);	
		
		if (!ch_cust_nm.equals("$$")) {
			gov_nm = ch_cust_nm;
		} else {
			gov_nm = String.valueOf(base.get("FIRM_NM"));
		}		
		
		email = String.valueOf(base.get("EMAIL"));
		
		ch_dem_dt = AddUtil.getReplace_dt(ch_dem_dt);
		ch_e_dem_dt = AddUtil.getReplace_dt(ch_e_dem_dt);

	
	
	if(seq_no.equals("")){//최초 과태료 납부자변경 등록하고 메일 보낼때 마지막 번호 가져오기.
		Hashtable ht = a_fdb.getForfeitSeq_no(c_id, m_id, l_cd);
		seq_no = String.valueOf(ht.get("SEQ_NO"));
	}	
	
//System.out.println("seq_no: "+seq_no);

   //과태료 내역  - 단기대여관련 정보
		f_bean = a_fdb.getForfeitDetailAll(ch_c_id, ch_m_id, ch_l_cd, ch_seq_no);
		ch_e_dem_dt = (String)f_bean.getE_dem_dt();//출금원장 등록시 입력된 날짜를 조회해서 가져옴. 
		
			//대차이용시
		if(!f_bean.getRent_s_cd().equals("")){//예약시스템 등록 차량이면
			//단기계약정보
			RentContBean rc_bean = rs_db.getRentContCase(f_bean.getRent_s_cd(), ch_c_id);
			//고객정보
			RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
			
			//대차관련 계약
			String rent_st = rc_bean.getRent_st();  //대차형태
			String org_l_cd = rc_bean.getSub_l_cd();
			String org_m_id = "";;
			
			if(rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("10")){
			
				//거래처정보
		        
				ClientBean client = al_db.getNewClient(rc_bean.getCust_id());
				gov_nm = client.getFirm_nm();
				
				org_m_id = ad_db.getRent_mng_id(org_l_cd );
				
				//cont_view
				Hashtable base2 = ad_db.getContEmail(org_m_id, org_l_cd);
				email = String.valueOf(base2.get("EMAIL"));	

				//일단 test	
				//email = "gillsun@naver.com";
				
			}
		
		}
	
	
//	if(gov_nm.equals("주식회사 폴리메탈")){//2012.10.26일 고객의 요청으로 인하여 메일을 발송하지 않도록 함.
//		email = "koobuk@gmail.com";
//	}else{
//		email = String.valueOf(base.get("EMAIL"));
//	}


	String file_name1 = request.getParameter("file_name")==null?"":request.getParameter("file_name");
	String file_name2 = request.getParameter("file_name2")==null?"":request.getParameter("file_name2");
	int idx			= 0;	
	int fcnt = 0;
	if(!file_name1.equals("")){
		fcnt ++;
	}
	if(!file_name2.equals("")){
		fcnt ++;
	}

	dem_dt = AddUtil.getReplace_dt(dem_dt);
	
	e_dem_dt = AddUtil.getDate(); //최종수정일로갱신됨. 
	e_dem_dt = AddUtil.getReplace_dt(e_dem_dt);
	
	// 과태료에 발송일 저장
	if(!a_fdb.updateForfeitPrintDemDt(ch_c_id, ch_m_id, ch_l_cd, Util.parseInt(ch_seq_no), user_id)) flag1 += 1;
		
	//일단 test	
	//System.out.println("email: "+email);
	//email = "gillsun@naver.com";	
	
	subject 		= gov_nm+"님, 고객위반 과태료 납부자변경 내역안내 입니다.";
	msg 			= gov_nm+"님, 고객위반 과태료 납부자변경 내역안내 입니다.";
		
	if(!email.equals("") && !email.equals("null")){
			//	1. d-mail 등록-------------------------------
			DmailBean d_bean = new DmailBean();
			
			d_bean.setSubject			(subject);
			d_bean.setSql				("SSV:"+email.trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"아마존카\"<tax300@amazoncar.co.kr>");
			d_bean.setMailto			("\""+gov_nm+"\"<"+email.trim()+">");
			d_bean.setReplyto			("\"아마존카\"<tax300@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<tax300@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(3);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(fcnt);
			d_bean.setGubun				("fine_bill_nbc_polic");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin계정
			d_bean.setG_idx				(fcnt);//admin계정
			d_bean.setMsgflag     		(0);
		
			d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/rent/email_fine_bill_nbc.jsp?m_id="+ch_m_id+"&l_cd="+ch_l_cd+"&c_id="+ch_c_id+"&dem_dt="+ch_dem_dt+"&e_dem_dt="+ch_dem_dt+"&seq_no="+Util.parseInt(ch_seq_no));
	
		   	
			seqidx = ImEmailDb.insertDEmail3(d_bean, "4", "", "+7", ch_c_id, ch_m_id, ch_l_cd, Util.parseInt(ch_seq_no));
			
	

//System.out.println("http://fms1.amazoncar.co.kr/mailing/rent/email_fine_bill_nbc.jsp?m_id="+ch_m_id+"&l_cd="+ch_l_cd+"&c_id="+ch_c_id+"&dem_dt="+ch_dem_dt+"&e_dem_dt="+ch_dem_dt+"&seq_no="+Util.parseInt(ch_seq_no));
		   
	}
	}
	}

%>

<script>
<%	if(seqidx > 0){%>
			alert("정상적으로 처리되었습니다.");
				
<%		}else{%>
			alert("에러발생!");
<%		}%>

</script>

</body>
</html>