<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.cont.*,acar.car_register.*, acar.client.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>	
<%@ include file="/acar/cookies.jsp" %>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>

</head>
<body leftmargin="15" topmargin="1"  >
	
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	
		
	String vid[] = request.getParameterValues("ch_l_cd");
	String list_size = "";
	String vid_num="";
	String img_url = "";
	
	double img_width 	= 680;
	double img_height 	= 1009;

	int vid_size = vid.length;
	int action_size = vid_size;
	
	int su = 0;
%>



<form action="" name="form1" method="POST" >

<table width='670' height="" border="0" cellpadding="0" cellspacing="0">
	<tr> 
		<td height="20" colspan=2 align='center'>&nbsp;</td>
	</tr>
	<tr bgcolor="#000000"> 
		<td colspan="2" align='center' height="10"> 
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr bgcolor="#A6FFFF" align="center"> 
					<td style="font-size : 8pt;" rowspan="2" width="5%"><font face="바탕">연번</font></td>
					<td style="font-size : 8pt;" rowspan="2" width="20%"><font face="바탕">고지서번호</font></td>
					<td style="font-size : 8pt;" rowspan="2" width="13%"><font face="바탕">차량번호</font></td>
					<td style="font-size : 8pt;" colspan="2" height="25"><font face="바탕">임차인</font></td>
				</tr>
				<tr bgcolor="#FFFFFF"> 
					<td style="font-size : 8pt;" width="15%" height="25" align="center" bgcolor="#A6FFFF"><font face="바탕">상호/성명</font></td>
					<td style="font-size : 8pt;" width="42%" align="center" bgcolor="#A6FFFF"><font face="바탕">JPG 없는 서류</font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="2" colspan="2"></td>
	</tr>
	<tr bgcolor="#000000">
		<td width="100%" height="10" align='center'>
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
<%
for(int j=0;j < vid_size;j++){
		//
	vid_num 	= vid[j];
	doc_id 		= vid_num.substring(0,12);
	gov_id		= vid_num.substring(vid_num.length()-3, vid_num.length());
	list_size 	= vid_num.substring(12);

	action_size = action_size + Util.parseInt(list_size);
	
	img_url		= doc_id;
	if(!img_url.equals("")){

	FineDocBn = FineDocDb.getFineDoc(img_url);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
	//과태료리스트
	Vector FineList = FineDocDb.getFineDocLists(img_url);
	

	
	
	String m_id[] = new String[FineList.size()];
	String l_cd[] = new String[FineList.size()];
	String ct_id[] = new String[FineList.size()];
	String c_id[] = new String[FineList.size()];
	

	String chk = "1";
	if(FineList.size()>0){
		for(int i=0; i<FineList.size(); i++){ 
			FineDocListBn = (FineDocListBean)FineList.elementAt(i);
			if(FineDocListBn.getCar_no().indexOf("허") != -1) chk = "0";
		}
	}
	String exp = "N";
	if(chk.equals("1") && FineGovBn.getGov_nm().equals("안산시 단원구청장")){
		exp = "Y";
	}
//System.out.println("img_url="+img_url+"<br><br>");
%>			
				<% if(FineList.size()>0){
					for(int i=0; i<FineList.size(); i++){ 
						FineDocListBn = (FineDocListBean)FineList.elementAt(i);
							m_id[i] = FineDocListBn.getRent_mng_id();
							l_cd[i] = FineDocListBn.getRent_l_cd();
							ct_id[i] = FineDocListBn.getClient_id();
							c_id[i] = FineDocListBn.getCar_mng_id();
							
							//스캔파일 검색
							String scan_17 = "";
							String scan_18 = "";
							String scan_2  = "";
							String scan_4  = "";
							int scan_no = 0;
							
							Vector fs = FineDocDb.getFind_scan(m_id[i], l_cd[i], ct_id[i], c_id[i]);
							int fs_size = fs.size();
								
							if(fs_size>0){
								for(int k = 0 ; k < fs_size ; k++){
									Hashtable ht = (Hashtable)fs.elementAt(k); 
									
									if(String.valueOf(ht.get("FILE_ST")).equals("17")){
										if(ht.get("FILE_TYPE").equals(".jpg")) scan_17 = "Y";
									}
									if(String.valueOf(ht.get("FILE_ST")).equals("18")){
										if(ht.get("FILE_TYPE").equals(".jpg")) scan_18 = "Y";
									}
									if(String.valueOf(ht.get("FILE_ST")).equals("4")){
										if(ht.get("FILE_TYPE").equals(".jpg")) scan_4 = "Y";
									}
									if(String.valueOf(ht.get("FILE_ST")).equals("2")){
										if(ht.get("FILE_TYPE").equals(".jpg")) scan_2 = "Y";
									}
																		
							}
							
							if(scan_17.equals("")){
								scan_no++;
							}
							if(scan_18.equals("")){
								scan_no++;
							}
							
							if(scan_4.equals("") || scan_2.equals("")){
								//거래처정보
								ClientBean client = al_db.getNewClient(FineDocListBn.getClient_id());
								//신분증
								if(scan_4.equals("")){
									if(!client.getClient_st().equals("2")){//개인									
										scan_4 = "Y";
									}else{
										scan_no++;
									}
								}
								//사업자등록증
								if(scan_2.equals("")){								
									if(client.getClient_st().equals("2")){//개인
										scan_2 = "Y";
									}else{
										scan_no++;
									}
								}
							}
							
							
							if(scan_no>0){
									
						su++;
					 %>
				<tr bgcolor="#FFFFFF" align="center">
					<td width="5%" height="32" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕"><%=su%></font></td>
					<td width="20%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getPaid_no()%></font></td>
					<td width="13%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getCar_no()%></font></td>
					<td width="15%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getFirm_nm()%></font></td>
					<td width="42%" style="font-size : 8pt;"><font face="바탕">
						<%if(!scan_17.equals("Y")){%>계약서 앞, <%}%>
						<%if(!scan_18.equals("Y")){%>계약서 뒤, <%}%>
						<%if(!scan_4.equals("Y")){%>신분증, <%}%>
						<%if(!scan_2.equals("Y")){%>사업자등록증<%}%>
						</font>
					</td>
				</tr>
					<%	}
					} %>
					
					<% 	}
					} %>
<%	}
	}%>					
			</table>
		</td>
	</tr>
</table>
</form>

</body>

</html>
