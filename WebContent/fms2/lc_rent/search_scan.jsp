<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔파일 페이지
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String file_st 	= request.getParameter("file_st")==null?"":request.getParameter("file_st");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String swd 	= request.getParameter("swd")==null?"":request.getParameter("swd");
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String str 	= request.getParameter("str")==null?"":request.getParameter("str");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//코드리스트 : 계약스캔파일구분
	CodeBean[] scan_codes = c_db.getCodeAll3("0028");
	int scan_code_size = scan_codes.length;
		
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;		
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}		
		popObj.location = theURL;
		popObj.focus();			

	}
	
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();	
	}
	
	
	function save()
	{
		document.form1.mode.value = 'AFTER';
		document.form1.submit();
	}
	
	
	function set_scan(file_name, file_path, file_type)
	
	{
		<%if(mode.equals("all_copy")){%>
		window.opener.form1.copy_file<%=idx%>.value 	= file_name;
		window.opener.form1.copy_path<%=idx%>.value 	= file_path;
		window.opener.form1.copy_type<%=idx%>.value 	= file_type;
		<%}else{%>
		window.opener.form1.copy_file.value 		= file_name;
		window.opener.form1.copy_path.value 		= file_path;
		window.opener.form1.copy_type.value 		= file_type;
		<%}%>
		
		window.close();
	}
	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<p>
<form name='form1' action='search_scan.jsp' method='post'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='str' value='<%=str%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='file_st' value='<%=file_st%>'>
<table border="0" cellspacing="0" cellpadding="0" width=750>
	<tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>스캔파일검색</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow_g.gif align=absmiddle>&nbsp;
	      <select name="file_st_nm" disabled>
                            <%for(int j = 0 ; j < scan_code_size ; j++){
                                CodeBean scan_code = scan_codes[j];	%>
                            <option value="<%=scan_code.getNm_cd()%>" <%if(file_st.equals(scan_code.getNm_cd())){%> selected<%}%>><%=scan_code.getNm()%></option>
                            <%}%> 
            </select></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>		
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='30'> 연번 </td>
					<td width="70" class='title'>계약일자</td>
				    <td width="80" class='title'>차량번호</td>
				    <td width="100" class='title'>차명</td>
				    <td width="70" class='title'>최초영업자</td>
				    <td width="110" class='title'>스캔파일</td>
				    <td width="170" class='title'>설명</td>
				    <td width="70" class='title'>등록일</td>
				    <td width="50" class='title'>보기</td>
				</tr>
<%	
		Vector vt = new Vector();
		
		if(from_page.equals("/acar/res_stat/res_rent_u.jsp") || from_page.equals("/acar/res_mng/res_rent_u.jsp")){
			vt = a_db.getSearchScanListS(client_id, file_st);
		}else{
			vt = a_db.getSearchScanList(client_id, file_st);
		}
		
		int size = vt.size();
		
		
		if(size > 0){			%>				
<%			for(int i = 0 ; i < size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	%>
				<tr>
					<td align='center'><%=i+1%></td>
					<td align="center"><%=ht.get("RENT_DT")%></td>
					<td align="center"><%=ht.get("CAR_NO")%></td>					
				    <td align="center"><%=ht.get("CAR_NM")%></td>
				    <td align="center"><%=ht.get("USER_NM")%></td>
				    <td align="center"><a href="javascript:set_scan('<%=ht.get("FILE_NAME")%>', '<%=ht.get("FILE_PATH_Y")%>', '<%=ht.get("FILE_TYPE")%>');"><%=ht.get("FILE_NAME")%> <%=ht.get("FILE_TYPE")%></a></td>
				    <td align="center"><%=ht.get("FILE_CONT")%></td>
				    <td align="center"><%=ht.get("REG_DT")%></td>
				    <td align="center">
					<%if(String.valueOf(ht.get("FILE_TYPE")).equals("")){%>
    			    <a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a> 
					<%}else{%>
    			    <a href="javascript:ScanOpen('<%=ht.get("FILE_NAME")%>','<%= AddUtil.replace(AddUtil.replace(AddUtil.replace(String.valueOf(ht.get("FILE_PATH")),"D:\\Inetpub\\wwwroot\\data\\",""),"D:\\Inetpub\\wwwroot\\data\\",""),"\\","/") %>','<%=ht.get("FILE_TYPE")%>')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a> 					
					<%}%>
    			    </td>
				</tr>
<%			}
		}else{		%>
				<tr>
					<td colspan='10' align="center"> 검색된 결과가 없습니다 </td>
				</tr>
<%		}
					%>
		  </table>
		</td>
	</tr>
</table>
</body>
</html>