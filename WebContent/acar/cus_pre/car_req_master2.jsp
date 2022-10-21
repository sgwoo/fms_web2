<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id"); 
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	
	
	if(String.valueOf(request.getParameterValues("multireg")).equals("") || String.valueOf(request.getParameterValues("multireg")).equals("null")){
		out.println("선택된 건이 없습니다.");
		return;
	}	
	
	String multireg[]  = request.getParameterValues("multireg");
	
	String multi_num="";
	String mng_id="";
	String c_id="";
	String l_cd="";
	String car_no="";		
	String m_id="";
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "01", "01");
		
	String m1_content="";
	
                     
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//저장하기
	function save(){
		var fm = document.form1;
	
		
		if( fm.gubun.value == 'Y'  ) {
		    if (  fm.m1_chk.value == '3'   ) {
		     }  else {
			alert("성수검사소 이외에  의뢰할 수 없습니다. 다시 확인하여 등록하세요..!!");
			return;
		     }	
		}			
		
		if( fm.m1_chk.value == '' ) {
			alert("의뢰내역을 선택하세요..!!");
			return;
		}
		
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'car_req_master_a2.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
</script>
</head>
<body leftmargin="15" >
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>

<%for(int i=0; i<multireg.length; i++) {
		
		multi_num=multireg[i];
		
		int s=0;
		String multi_value[] = new String[5];
		
		StringTokenizer tokens = new StringTokenizer(multi_num, "^");
		
		while(tokens.hasMoreTokens()) {
			multi_value[s] = tokens.nextToken();
			s++;
		}
		
		mng_id	= multi_value[0];
		c_id		= multi_value[1];
		car_no	= multi_value[2];
		l_cd		= multi_value[3];
		m_id		= multi_value[4];
		%>

<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='car_no' value='<%=car_no%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='mng_id' value='<%=mng_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
				
<%}%>


<input type='hidden' name='gubun' value='<%=gubun%>'>
<table border=0 cellspacing=0 cellpadding=0 width=500>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량 검사의뢰 다중등록 : 총 <%=multireg.length%>대</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="25%">의뢰</td>
                    <td>&nbsp;<SELECT NAME="m1_chk" >
                    			<option value=""  selected> --선택 -- </option>
                    		    <option value="2" >담당자가 직접 검사진행</option> 
                    		    <option value="3" >성수자동차 검사의뢰 요청</option>                 
                    		    <option value="8">차비서 검사의뢰 요청</option> 
                    		    <option value="A">성서현대(대구) 검사의뢰 요청</option> 
        		        </SELECT>
        	        </td>
    		    </tr>	
    		  
    		    <tr> 
                    <td class=title  width="25%" >요구사항</td>
                    <td colspan="2" >&nbsp; 
                      <textarea name='m1_content' rows='3' cols='60' ><%=m1_content%></textarea>
                    </td>
                </tr>	                
               
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
         <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>
         <input type='checkbox' name="sms_yn" value='Y' >차량이용자에게 자동 안내 문자 발송
        <a href="javascript:save();"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
        <% } %>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
    
    <tr>
    	<td><font color=red>&nbsp;**</font>&nbsp;대행업체를 검사의뢰 하세요!!! <br>차령연장 임시검사는 우선 성수검사소에서만 진행합니다. <br>지점은  담당자가 진행합니다.<br>
    			<font color=red>&nbsp;**</font>&nbsp;차량이용자가 미등록되어 있는 경우  문자가 발송되지 않습니다. 발송을 원할 경우 목록에서 핸드폰 아이콘을 눌러서 발송할 수 있습니다!!!	
    	</td>
    <tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
