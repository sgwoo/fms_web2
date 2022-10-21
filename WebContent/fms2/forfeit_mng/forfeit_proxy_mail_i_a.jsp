<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.admin.*,  acar.client.*,  acar.res_search.*,  acar.im_email.*, tax.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<% 
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	int flag1 = 0;
	int count = 0;	
	String gubun1 	= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
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
	
	//과태료정보
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
		
		//파싱
	for(int i=0; i<chk_cd.length;i++){
		vid_num=chk_cd[i];
		
	//	System.out.println("vid_num="+vid_num);
			
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
		
		//일단 test	
	//	email = "dev@amazoncar.co.kr";


		   //과태료 내역  - 단기대여관련 정보
		f_bean = a_fdb.getForfeitDetailAll(ch_c_id, ch_m_id, ch_l_cd, ch_seq_no);
		
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
			}
		
		}
				
		// 과태료에 발송일 저장
	 	if(!a_fdb.updateForfeitPrintDemDt(ch_c_id, ch_m_id, ch_l_cd, Util.parseInt(ch_seq_no), user_id)) flag1 += 1;
	 			
		subject 		= gov_nm+"님, 선납과태료 (재발행)청구서 입니다.";
		msg 			= gov_nm+"님, 선납과태료 (재발행)청구서 입니다.";
		
		//거래처 메일이 있으면
		
		if(!email.equals("") && !ch_gubun.equals(ch_m_id+ch_l_cd+ch_dem_dt+ch_e_dem_dt) ){
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
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				("fine");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin계정
			d_bean.setG_idx				(1);//admin계정
			d_bean.setMsgflag     		(0);	
		
			d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/rent/email_fine_bill.jsp?m_id="+ch_m_id+"&l_cd="+ch_l_cd+"&dem_dt="+ch_dem_dt+"&e_dem_dt="+ch_e_dem_dt);
					

			seqidx = ImEmailDb.insertDEmail3(d_bean, "4", "", "+7", ch_c_id, ch_m_id, ch_l_cd, Util.parseInt(ch_seq_no));
		    ch_gubun = ch_m_id + ch_l_cd + ch_dem_dt + ch_e_dem_dt;
		    count++;			
		}
		
//	   System.out.println("mail_i ch_m_id=" +ch_m_id + "|ch_l_cd=" + ch_l_cd + "|ch_dem_dt=" + ch_dem_dt+"|ch_e_dem_dt="+ch_e_dem_dt);
	  
	}	
	
%>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(count >= 1){%>
	alert("발행되었습니다.");	
//	parent.location.href='forfeit_de_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&gubun1=2&gubun2=<%=gubun2%>';
	parent.location.href = "forfeit_de_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&gubun1=2&gubun2=<%=gubun2%>";

<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%}%>
//-->
</script>
</body>
</html>