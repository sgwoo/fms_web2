<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�ڵ������� �˻� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchCarReg();
}
function SearchCarReg()
{ 
	var theForm = document.CarRegSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}

function ChangeDT(arg)
{
	var theForm = document.CarRegSearchForm;
	if(arg=="st_dt")
	{
	theForm.st_dt.value = ChangeDate(theForm.st_dt.value);
	}else if(arg=="end_dt"){
	theForm.end_dt.value = ChangeDate(theForm.end_dt.value);
	}
}


//���÷��� Ÿ��(�˻�)-������ȸ ���ý�
	function cng_input1(){
		var fm = document.CarRegSearchForm;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ //�Ⱓ
			td_dt.style.display	 = '';
		}else{
			if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //�˻�	
			}				
			td_dt.style.display	 = 'none';
		}
	}		
	
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���¾�ü > ����⵿/�˻� ���� > <span class=style5>�ڵ����˻�û��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>	
      
	<form action="./car_d1_list_sc.jsp" name="CarRegSearchForm" method="POST" target="c_foot">
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>	
	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
	<input type='hidden' name='s_kd' value='2'> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width=100%>
            	<tr>
            		<td width='200'><img src=/acar/images/center/arrow_gsgg.gif align=absmiddle>&nbsp;
            	  <select name='gubun3'>
                      <!--  <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>�Ƿ�����</option> -->
                     <!--   <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>�˻�����</option> -->				
                        <option value='3' <%if(gubun3.equals("3")){%>selected<%}%>>û������</option>  
               <!--         <option value='4' <%if(gubun3.equals("3")){%>selected<%}%>>��������</option> -->
                        
                      </select>
                      
                      <select name="gubun2" onChange="javascript:cng_input1()">
                        <option value="5" <%if(gubun2.equals("3")){%>selected<%}%>>���</option>
                        <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>����</option>
                        <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>�Ⱓ</option>
                    <!--    <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>�˻�</option> -->
                      </select>
                    </td>

                    <td align="left" width="155"> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td id='td_dt' <%if(gubun2.equals("4")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                            <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                            ~ 
                            <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                          </td>
                        </tr>
                      </table>
                    </td>  
               
               	<td >&nbsp;
        		      <select name='gubun4'>
        			    <%if(user_id.equals("000140")){%>
                        		<option value='007410' 		 <%if(gubun4.equals("007410")){%>selected<%}%>>�����ڵ���</option>
        			    <%}else if(user_id.equals("000196")){%>			  
                        		<option value='008411'       		 <%if(gubun4.equals("008411")){%>selected<%}%>>������Ƽ�ڸ���</option>	 
                           <%}else if(user_id.equals("000332")){%>			  
                        		<option value='011614'       		 <%if(gubun4.equals("011614")){%>selected<%}%>>����</option>	
                          <%}else if( user_id.equals("000198")  ){%>		  
                        		<option value='008462'       		 <%if(gubun4.equals("008462")){%>selected<%}%>>��������</option>	  		 	
        			    <%}else{%>
        			    	<option value='' >��ü</option>        			
		                    <option value='007410' 		 <%if(gubun4.equals("007410"))		{%>selected<%}%>>�����ڵ���</option>
		                    <option value='011614'       <%if(gubun4.equals("011614"))		{%>selected<%}%>>����</option>
		                   <option value='000286'       <%if(gubun4.equals("000286"))		{%>selected<%}%>>��������</option>
		                   <option value='011827'       <%if(gubun4.equals("011827"))		{%>selected<%}%>>�������ڵ����˻��</option>
		                   <option value='010097'       <%if(gubun4.equals("010097"))		{%>selected<%}%>>�����ڵ���</option>
		                      <option value='008462'       <%if(gubun4.equals("008462"))			{%>selected<%}%>>��������</option>
		                  <!--   <option value='008411'       <%if(gubun4.equals("008411"))			{%>selected<%}%>>������Ƽ�ڸ���</option> -->
		                         
                      	  
        			    <%}%>
                      </select>
                	</td>                   
        			      			            
            	   <td><a href="javascript:SearchCarReg()"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
				</tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>
