<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");

	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		if(confirm('등록하시겠습니까?'))
		{
			var fm = document.form1;
			if((fm.t_reg_dt.value == '') || !isDate(fm.t_reg_dt.value))			{	alert('등록일을 확인하십시오');		return;	}		
			if(fm.t_content.value == '')							{	alert('내용을 확인하십시오');	return;	}
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
		
			fm.target='i_no';
			fm.action='car_board_memo_i_a.jsp';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='from_page' value='car_board'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>	
  
   <tr>
	    <td class=line2></td>
	</tr>
    <tr>
	    <td class='line'  width='834'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>					
                    <td width='14%' class='title'>구분</td>
                    <td width='12%' class='title'>계약번호</td>
                    <td width='10%' class='title'>작성자</td>
        		        <td width='10%' class='title'>작성일</td>
        		       <td width='54%' class='title'>특이사항</td>
                   
		        </tr>
	        </table>
	    </td>
	    <td width='17'>&nbsp;</td>
    </tr>	
	<tr>
		<td colspan='2'>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
					  <iframe src="car_board_sc_in.jsp?car_mng_id=<%=car_mng_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&gubun=<%=gubun%>" name="i_no" width="100%" height="410" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
        <td colspan='2' class=line2></td>
    </tr>	
	<tr>
		<td colspan='2' class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="12%"> 구분 </td>
                    <td width=15%>&nbsp; 
                    	<select name="t_mm_st">
            				    <option value="MA" <%if(gubun.equals("MA")){%>selected<%}%>>검사&nbsp;&nbsp;</option>
            				    <option value="AC" <%if(gubun.equals("AC")){%>selected<%}%>>사고&nbsp;&nbsp;</option>
            				    <option value="ET" <%if(gubun.equals("ET")){%>selected<%}%>>기타&nbsp;&nbsp;</option>
            			    </select>
                    </td>
                    <td class='title' width="12%"> 등록일 </td>
                    <td width=15%>&nbsp; <input type='text' name='t_reg_dt' size='12' class='text' onBlur='javascript:this.value = ChangeDate(this.value);' value = '<%=Util.getDate()%>'></td>
                  
                   
                </tr>
                <tr> 
                    <td class='title'> 내용</td>
                    <td colspan='5'>&nbsp; <textarea name='t_content' rows='4' cols='106'></textarea> 
                    </td>
                </tr>
            </table>
		</td>
	</tr>
	
	<tr>
		<td colspan='2' align='right'> 
		  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		  <a id="submitLink" href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
		  <%}%>
		  <a href="javascript:parent.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>	

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>
