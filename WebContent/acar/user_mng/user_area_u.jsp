<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//사용자별 정보 조회 및 수정 페이지
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	
	// 채권그룹 
	CodeBean[] banks = c_db.getCodeAll("0029");
	int bank_size = banks.length;
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정
	function UserUp(){
		var theForm = document.form1;
		if(!confirm('수정하시겠습니까?')){ return; }
		theForm.target="i_no";
		theForm.submit();
	}

//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body  onLoad="self.focus()">
<center>
<form action="user_area_u_a.jsp" name="form1" method="POST" >
  <input type="hidden" name="user_id" value="<%=user_id%>">  
<table border=0 cellspacing=0 cellpadding=0 width=450>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 사용자관리 > <span class=style5>채권 그룹 관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>			    	
                    <td class=title width=75>이름</td>			    	
                    <td width=150>&nbsp;<%=user_bean.getUser_nm()%></td>			    	
                    <td class=title width=65>부서</td>			        
                    <td width=160>&nbsp;<%=user_bean.getDept_nm()%></td>
			    </tr>
                <tr>
        		    <td class=title>채권그룹</td>
        	        <td colspan=3>&nbsp;
					  <select name="area_id">
                  	    <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
        					
                              <option value='<%= bank.getCode()%>' <%if(user_bean.getArea_id().equals(bank.getCode())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>					
                	  </select>
					</td>			    	
               
           	    </tr>
             
            </table>
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
    			    <td align="right">
    			
    		        <a href="javascript:UserUp()"><img src=../images/pop/button_modify.gif border=0></a>
    			
     		        <a href="javascript:self.close();window.close();"><img src=../images/pop/button_close.gif border=0></a>
    			    </td>
    </tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>