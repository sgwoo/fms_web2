<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	//스캔관리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st		= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	int    fee_size		= request.getParameter("fee_size")==null?1:AddUtil.parseInt(request.getParameter("fee_size"));
	int    h_scan_num	= request.getParameter("h_scan_num")==null?1:AddUtil.parseInt(request.getParameter("h_scan_num"));
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	String file_st = "";
	String file_cont = "";
	
	String vid1[] 		= request.getParameterValues("h_file_st");
	String vid2[] 		= request.getParameterValues("h_file_cont");
	
	int vid_size 		= vid1.length;
	
	if(vid_size>12) vid_size = 12;
	
	//System.out.println("[스캔일괄복사]"+rent_l_cd+", "+user_id);
	
	//코드리스트 : 계약스캔파일구분
	CodeBean[] scan_codes = c_db.getCodeAll3("0028");
	int scan_code_size = scan_codes.length;
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		fm = document.form1;
				
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
//		fm.target = "i_no";
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/lc_rent_reg_scan_all_copy_a.jsp";
		fm.submit();
	}
	
	//관계자 조회
	function search_scan(idx, file_st){
		var fm = document.form1;		
		window.open("search_scan.jsp?client_id=<%=base.getClient_id()%>&file_st="+file_st+"&idx="+idx+"&mode=all_copy", "SEARCH_SCAN", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
	}	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"		value="<%=rent_st%>">
  <input type='hidden' name="file_cnt" 		value="<%=vid_size%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>스캔일괄복사등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="4%" class=title>연번</td>
                  <td width="8%" class=title>계약</td>				  
                  <td width="23%" class=title>구분</td>
                  <td width="25%" class=title>설명</td>		  
                  <td width="40%" class=title>스캔파일</td>
                </tr>							
		<%for(int i=0;i < vid1.length-1;i++){
			file_st 	= vid1[i];
			file_cont 	= vid2[i];%>
                <tr>
                    <td <%if(i%2==0)%>class=is<%%> align="center"><%=i+1%></td>
                    <td <%if(i%2==0)%>class=is<%%> align="center">
		      <select name="file_rent_st<%=i+1%>">					  
                        <option value="1" <%if(rent_st.equals("1")){%>selected<%}%>>신규</option>
			<%for(int j = 1 ; j < fee_size ; j++){%>
                        <option value="<%=j+1%>" <%if(rent_st.equals(String.valueOf(j+1))){%>selected<%}%>><%=j%>차연장</option>						
			<%}%>
                      </select> 			
                    </td>
                    <td <%if(i%2==0)%>class=is<%%> align="center">
        	      <select name="file_st<%=i+1%>">
                            <%for(int j = 0 ; j < scan_code_size ; j++){
                                CodeBean scan_code = scan_codes[j];	%>
                            <option value="<%=scan_code.getNm_cd()%>" <%if(file_st.equals(scan_code.getNm_cd())){%> selected<%}%>><%=scan_code.getNm()%></option>
                            <%}%>
                      </select>
                    </td>	
                    <td <%if(i%2==0)%>class=is<%%> align="center">
        		<input type="text" name="file_cont<%=i+1%>" size="30" class="text" value='<%=file_cont%>'>
                    </td>
                    <td <%if(i%2==0)%>class=is<%%> align="center">
        		<!--<input type="file" name="filename<%=i+1%>" size="30">-->
        		<input type="text" name="copy_file<%=i+1%>" size="40" class="text">&nbsp;<span class="b"><a href='javascript:search_scan(<%=i+1%>, document.form1.file_st<%=i+1%>.options[document.form1.file_st<%=i+1%>.selectedIndex].value)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        		<input type='hidden' name="copy_path<%=i+1%>" value="">
        		<input type='hidden' name="copy_type<%=i+1%>" value="">
                    </td>									
                </tr>	
		<%}%>		
            </table>
        </td>
    </tr>
    <tr>
        <td>☞ 2010년5월1일 부터 대여개시후계약서, 사업자등록증, 신분증 스캔을 JPG로 하지 않으실 경우 스캔 등록이 되지 않습니다.</td>
    </tr>	
    <tr>
        <td>☞ <b>대여개시후계약서(앞/뒤)jpg</b>는 <b>차량번호, 대여개시일, 대여만료일</b>이 작성된것으로 스캔하세요.</td>
    </tr>
    <!--
    <tr>
        <td>☞ 본사에서는 신차의 <b>대여개시후계약서(앞/뒤)jpg</b>는 이의상반장님이 작업하시니 담당자는 하지 마세요.</td>
    </tr>
    <tr>
        <td>☞ 파일은 최대 10개만 업로드 할수 있습니다.</td>
    </tr>
    -->
    <tr>
        <td>☞ 파일을 선택한 것만 등록됩니다.</td>
    </tr>
    <tr>
        <td align="right">
            <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <%}%>
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
