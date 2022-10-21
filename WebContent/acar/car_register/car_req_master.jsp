<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id"); 
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id"); //담당자
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd"); //계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");  //gubun:ag :차령연장용 임시검사 - 총무팀 의뢰
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "04", "01");
	
		
	String m1_content=" 차령연장용 임시검사의뢰합니다. 자동차등록증 원본이 없을 경우 연락주세요";
	//차량정보
	Hashtable res = rs_db.getCarMaintInfo(c_id);	
			
         if (!String.valueOf(res.get("M1_CONTENT")).equals("") ) {
              m1_content = String.valueOf(res.get("M1_CONTENT"));         
         }
	
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
		
		
	//	if( fm.m1_chk.value == '5' ) {
	//		alert("일등전국탁송에  의뢰할 수 없습니다. 다시 확인하여 등록하세요..!!");
	//		return;
	//	}			
		
		if( fm.m1_chk.value == '' ) {
			alert("검사대행업체를 선택하세요..!!");
			return;
		}
		
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'car_req_master_a.jsp';
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
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='car_no' value='<%=car_no%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='mng_id' value='<%=mng_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<table border=0 cellspacing=0 cellpadding=0 width=500>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%> 차량 차령연장용 임시검사의뢰 등록</span></td>
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
                    		   <option value="" <%if( res.get("M1_CHK").equals(""))%> selected<%%>> --선택 -- </option>
                     		   <option value="0" <%if( res.get("M1_CHK").equals("0"))%> selected<%%>>해당사항 없음</option>
                    		    <option value="3" <%if( res.get("M1_CHK").equals("3"))%> selected<%%>>성수자동차 검사의뢰 요청</option> 
                    		    <%-- <option value="5" <%if( res.get("M1_CHK").equals("5"))%> selected<%%>>일등전국탁송 검사의뢰 요청</option> --%>
                    		    <option value="5" <%if( res.get("M1_CHK").equals("5"))%> selected<%%>>에프앤티코리아 검사의뢰 요청</option> 
        		        </SELECT>        		  
        		         <%if( res.get("M1_CHK").equals("3")) {%> 의뢰일 : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        		         <%if( res.get("M1_CHK").equals("5")) {%> 의뢰일 : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        	        </td>
    		    </tr>	
    		  
    		    <tr> 
                    <td class=title  width="25%" >요구사항</td>
                    <td colspan="2" >&nbsp; 
                      <textarea name='m1_content' rows='3' cols='60' ><%=m1_content%></textarea>
                    </td>
                </tr>	
                <tr> 
                    <td class=title  width="25%" >진행 특이사항</td>
                    <td colspan="2" >&nbsp; 
                     <textarea name='che_remark' rows='3' cols='60' readonly ><%=(String)res.get("CHE_REMARK") %></textarea>
                    </td>
                </tr>	
                
               
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><%if( !res.get("M1_CHK").equals("1") && !res.get("M1_CHK").equals("2") && !res.get("M1_CHK").equals("3")  && !res.get("M1_CHK").equals("5") ){ %>
        <a href="javascript:save();"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
        <% } %> 
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
    
    <tr>
    	<td><font color=red>&nbsp;**</font>&nbsp;대행업체를 검사의뢰 하세요!!! <br>차령연장 임시검사는 우선 성수검사소에서만 진행합니다. <br>지점은 현재처럼 담당자가 진행합니다.</td>
    <tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
