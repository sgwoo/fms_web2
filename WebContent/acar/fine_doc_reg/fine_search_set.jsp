<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
		
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
	
	String s_idx = request.getParameter("s_idx")==null?"0":request.getParameter("s_idx");
	
  //선택리스트
	String vid[] = request.getParameterValues("cho_id");
	
	String vid_num="";
	String ch_m_id="";
	String ch_l_cd="";
	String ch_c_id="";
	String ch_seq_no="";
	String ch_rent_st="";
	String ch_vio_dt="";
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
	<script language='javascript'>
  <!--
  
  	var fm = parent.opener.parent.c_foot.document.form1;
  	
  	var s_idx = toInt(fm.size.value);

    	
  	<%for(int i=0; i<vid.length;i++){
  	
				vid_num=vid[i];
				int s=0; 
				String app_value[] = new String[6];	
				StringTokenizer st = new StringTokenizer(vid_num,"/");
				while(st.hasMoreTokens()){
					app_value[s] = st.nextToken();
					s++;
				}
				ch_m_id 		= app_value[0];
				ch_l_cd 		= app_value[1];
				ch_c_id 		= app_value[2];
				ch_seq_no 	= app_value[3];
				ch_rent_st 	= app_value[4] ==null?"":AddUtil.replace(app_value[4]," ","");
				ch_vio_dt 	= app_value[5];
						
				Hashtable fine = new Hashtable();
						
				//대여기간에 맞는 과태료 입력 확인
				ch_rent_st = afm_db.getFineSearchRentst(ch_m_id, ch_l_cd, ch_vio_dt);
		%>
			
			parent.opener.parent.c_foot.tr_fine<%=AddUtil.parseInt(s_idx)+i%>.style.display = '';	
			
	<%	if(ch_rent_st.equals("") || ch_rent_st.equals("null")){
					fine = afm_db.getFineExpListExcel(ch_m_id, ch_l_cd, ch_c_id, ch_seq_no);
  	%>
  				fm.paid_no[s_idx+<%=i%>].value = '<%=fine.get("CAR_NO")%>차량 과태료 위반일자<%=ch_vio_dt%>와 등록된 계약의 대여기간이 맞지 않습니다. 확인하세요.';
  	<%	}else{
  		
					fine = afm_db.getFineExpListExcel(ch_m_id, ch_l_cd, ch_c_id, ch_seq_no, ch_rent_st);
						
					String rent_s_cd 	= String.valueOf(fine.get("RENT_S_CD"));
					String scan 	 		= String.valueOf(fine.get("SCAN_FILE"));
					String file_name 	= String.valueOf(fine.get("FILE_NAME"));
					String client_st 	= String.valueOf(fine.get("CLIENT_ST"));
					String client_id 	= String.valueOf(fine.get("CLIENT_ID"));
					String firm_nm 		= String.valueOf(fine.get("FIRM_NM"));
					String ssn 				= String.valueOf(fine.get("SSN"));
					String enp_no			= String.valueOf(fine.get("ENP_NO"));
					String rent_start_dt	= String.valueOf(fine.get("RENT_START_DT"));
					String rent_end_dt		= String.valueOf(fine.get("RENT_END_DT"));
					//아마존카 차량 -> 보유차는 대차연동
					if(!rent_s_cd.equals("")){
						client_id 			= String.valueOf(fine.get("CLIENT_ID2"));
						firm_nm 				= String.valueOf(fine.get("FIRM_NM2"));
						ssn 						= String.valueOf(fine.get("SSN2"));
					 	enp_no					= String.valueOf(fine.get("ENP_NO2"));
					 	rent_start_dt		= String.valueOf(fine.get("RENT_START_DT2"));
					 	rent_end_dt			= String.valueOf(fine.get("RENT_END_DT2"));
					}
					if(!client_st.equals("1") && ssn.length()>6){
						ssn = ssn.substring(0,6);
					}
				
  	%>
  				fm.car_mng_id[s_idx+<%=i%>].value = '<%=ch_c_id%>';
  				fm.seq_no[s_idx+<%=i%>].value = '<%=ch_seq_no%>';
  				fm.rent_mng_id[s_idx+<%=i%>].value = '<%=ch_m_id%>';
  				fm.rent_l_cd[s_idx+<%=i%>].value = '<%=ch_l_cd%>';
  				fm.con_agnt_email[s_idx+<%=i%>].value = '<%=fine.get("CON_AGNT_EMAIL")%>';
  				fm.rent_s_cd[s_idx+<%=i%>].value = '<%=rent_s_cd%>';
  				fm.rent_st[s_idx+<%=i%>].value = '<%=ch_rent_st%>';
  				fm.prepare[s_idx+<%=i%>].value = '<%=fine.get("PREPARE")%>';
  				fm.client_id[s_idx+<%=i%>].value = '<%=client_id%>';
  				fm.vio_dt[s_idx+<%=i%>].value = '<%=ch_vio_dt%>';
  				fm.paid_no[s_idx+<%=i%>].value = '<%=fine.get("PAID_NO")%>';
  				fm.car_no[s_idx+<%=i%>].value = '<%=fine.get("CAR_NO")%>';
  				fm.firm_nm[s_idx+<%=i%>].value = '<%=firm_nm%>';
  				fm.ssn[s_idx+<%=i%>].value = '<%if(client_st.equals("1")){%><%=AddUtil.ChangeEnp(ssn)%><%}else{%><%=ssn%><%}%>';
  				fm.enp_no[s_idx+<%=i%>].value = '<%=AddUtil.ChangeEnp(enp_no)%>';
  				fm.rent_start_dt[s_idx+<%=i%>].value = '<%=rent_start_dt%>';
  				fm.rent_end_dt[s_idx+<%=i%>].value = '<%=rent_end_dt%>';
  				fm.lic_no[s_idx+<%=i%>].value = '<%=fine.get("LIC_NO")%>';	//운전면허번호 추가(20180830)
  	<%	}%>
  	<%}%>
  	
  	fm.size.value = toInt(fm.size.value)+<%=vid.length%>;
  	
  	parent.document.form1.s_idx.value = fm.size.value;
  	
  	alert('<%=vid.length%>건 반영되었습니다.');
  	
  	parent.parent.window.close();
  
	//-->
	</script>
</body>
</html>
