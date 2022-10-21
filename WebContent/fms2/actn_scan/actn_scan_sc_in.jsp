<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.actn_scan.*, acar.common.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>


<%
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	Actn_scanDatabase acsc_db = Actn_scanDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String acar_id = login.getCookieValue(request, "acar_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");

	int count = 0;
	
	Vector vt = acsc_db.Actn_scan_all(dt, st_year, st_mon,  ref_dt1,  ref_dt2);
	int vt_size = vt.size();
	
	int size = 0;
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
var popObj = null;
<!--
	
	//스캔파일열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/action/actn_scan/"+theURL;
		
		popObj =window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}

	//삭제
	function Actn_scanDel(nm, dt, su){
		fm = document.form1;
		if(!confirm('삭제하시겠습니까?'))	return;	
		fm.action = "actn_scan_del.jsp?actn_nm="+nm+"&actn_dt="+dt+"&actn_su="+su;	
		fm.submit();
	}

	//스캔등록
	function scan_reg(actn_id, actn_dt, actn_su){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&actn_id="+actn_id+"&actn_dt="+actn_dt+"&actn_su="+actn_su, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr> 
		<td class="line">
			<table  width="100%" border="0" cellspacing="1" cellpadding="0">
			<% if(vt.size()>0){
				for(int i=0; i< vt.size(); i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				String content_code = "ACTN_SCAN";
				String content_seq  = String.valueOf(ht.get("ACTN_ID"))+String.valueOf(ht.get("ACTN_DT"))+String.valueOf(ht.get("ACTN_SU"));

				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				int attach_vt_size = attach_vt.size();
				
				String file_type1 = "";
				String seq1 = "";
				String file_type2 = "";
				String seq2 = "";
				String file_type3 = "";
				String seq3 = "";
				
				String file_name1 = "";
				String file_name2 = "";
				String file_name3 = "";
				
				for(int j=0; j< attach_vt.size(); j++){
					Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
					
					if((content_seq+1).equals(aht.get("CONTENT_SEQ"))){
						file_name1 = String.valueOf(aht.get("FILE_NAME"));
						file_type1 = String.valueOf(aht.get("FILE_TYPE"));
						seq1 = String.valueOf(aht.get("SEQ"));
						
					}else if((content_seq+2).equals(aht.get("CONTENT_SEQ"))){
						file_name2 = String.valueOf(aht.get("FILE_NAME"));
						file_type2 = String.valueOf(aht.get("FILE_TYPE"));
						seq2 = String.valueOf(aht.get("SEQ"));
						
					}else if((content_seq+3).equals(aht.get("CONTENT_SEQ"))){
						file_name3 = String.valueOf(aht.get("FILE_NAME"));
						file_type3 = String.valueOf(aht.get("FILE_TYPE"));
						seq3 = String.valueOf(aht.get("SEQ"));

					}
				}	
			%> 
				<tr>
					<td align="center" width=10%><%=i+1%>
					<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)||nm_db.getWorkAuthUser("경매처리",ck_acar_id)){%>					
						<a href="javascript:Actn_scanDel('<%=ht.get("ACTN_NM")%>','<%=ht.get("ACTN_DT")%>','<%=ht.get("ACTN_SU")%>')" onMouseOver="window.status=''; return true">D</a>
					<%}%>
					</td>
					<td align="center" width=25%><%=ht.get("ACTN_NM")%></td>
					<td align="center" width=10%><%=ht.get("ACTN_SU")%>회</td>
					<td align="center" width=10%><%=AddUtil.ChangeDate2((String)ht.get("ACTN_DT"))%></td>
					<td align="center" width=15%>
					<%if(!ht.get("FILE_NAME1").equals("")){%>
					<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME1")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">
					<img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
					<%}else{%>
						<%if(file_name1.equals("")){%>
							<a href="javascript:scan_reg('<%=ht.get("ACTN_ID")%>','<%=ht.get("ACTN_DT")%>','<%=ht.get("ACTN_SU")%>')"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
						<%}else{%>
							<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
								<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
							<%}else{%>
								<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
							<%}%>
						 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
						<%}%>
					<%}%>
					</td>
					<td align="center" width=15%>
					<%if(!ht.get("FILE_NAME2").equals("")){%>
					<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME2")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">
					<img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
					<%}else{%>
						<%if(file_name2.equals("")){%>
							<a href="javascript:scan_reg('<%=ht.get("ACTN_ID")%>','<%=ht.get("ACTN_DT")%>','<%=ht.get("ACTN_SU")%>')"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
						<%}else{%>
							<%if(file_type2.equals("image/jpeg")||file_type2.equals("image/pjpeg")||file_type2.equals("application/pdf")){%>
								<a href="javascript:openPopP('<%=file_type2%>','<%=seq2%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
							<%}else{%>
								<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq2%>" target='_blank'><%=file_name2%></a>
							<%}%>
						 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq2%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
						 <%}%>
					 <%}%>
					</td>
					<td align="center" width=15%>
					<%if(!ht.get("FILE_NAME3").equals("")){%>
					<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME3")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">
					<img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
					<%}else{%>
						<%if(file_name3.equals("")){%>
							<a href="javascript:scan_reg('<%=ht.get("ACTN_ID")%>','<%=ht.get("ACTN_DT")%>','<%=ht.get("ACTN_SU")%>')"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
						<%}else{%>
							<%if(file_type3.equals("image/jpeg")||file_type3.equals("image/pjpeg")||file_type3.equals("application/pdf")){%>
								<a href="javascript:openPopP('<%=file_type3%>','<%=seq3%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
							<%}else{%>
								<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq3%>" target='_blank'><%=file_name3%></a>
							<%}%>
						 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq3%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
						<%}%>
					<%}%>
					</td>
				</tr>
			<%}
}else{%>
				<tr>
					<td colspan='' align='center'>등록된 데이터가 없습니다</td>
				</tr>
<%}%>
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</body>
</html>
