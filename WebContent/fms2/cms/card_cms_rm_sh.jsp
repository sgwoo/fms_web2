<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc 	= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		var fm = document.form1;
		if(fm.gubun3.value == '3' && fm.st_dt.value == '' && fm.end_dt.value == ''){
			if(fm.t_wd.value == '' && fm.gubun1[0].checked == true ) {
			    if (fm.gubun4.value == '9' || fm.gubun4.value == '2'    ){
			    } else {			    
			             alert('�˻�� �Է��Ͻʽÿ�.'); 
			             return;
			    }
			}    
			if(fm.t_wd.value == '' && fm.gubun1[1].checked == true && fm.gubun4.value != '9'){ alert('�˻�� �Է��Ͻʽÿ�.'); return;}		
		}				
		fm.submit();				
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin="15">

<form name='form1' action='card_cms_rm_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 

<div class="navigation">
	<span class=style1>�繫ȸ�� > ī��CMS���� ></span><span class=style5>����Ʈī��CMS����</span>
</div>
<div class="search-area">
	<label><i class="fa fa-check-circle"></i> ��ȸ���� </label>
	 <select id='gubun2'  name='gubun2' class="select" style="width:100px;">
            <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>��û����</option>
     </select>		
     
       <select id="gubun3" name='gubun3' class="select" style="width:100px;">
                    <option value="3" <%if(gubun3.equals("3"))%>selected<%%>>�Ⱓ</option>					
                    <option value="4" <%if(gubun3.equals("4"))%>selected<%%>>����</option>				  
                    <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>����</option>
                    <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>���</option>
      </select>		
    	  &nbsp;				  
        <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
		  ~
		  <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text">  
	&nbsp;&nbsp;
	
	<label><i class="fa fa-check-circle"></i> �˻����� </label>
	<select id="s_kd" name="s_kd" class="select" style="width:100px;">
		     <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
            <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>
            <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>
	</select>
	&nbsp;
	<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	&nbsp;&nbsp;
	<input type="button" class="button" value="�˻�" onclick="search()"/>
</div>


    <!--
                <td width="10%" class="title">������</td>
                <td width="40%">&nbsp;
                  <select name='gubun4'>
                    <option value="">��ü</option>  
                    <option value="0" <%if(gubun4.equals("0"))%>selected<%%>>�ű�</option>
                    <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>�űԽ�û��</option>				
		 <option value="2" <%if(gubun4.equals("2"))%>selected<%%>>�űԽ�û�Ҵ�</option>					
                    <option value="3" <%if(gubun4.equals("3"))%>selected<%%>>��û�Ϸ�</option>
                    <option value="11" <%if(gubun4.equals("11"))%>selected<%%>>����</option>
                    <option value="12" <%if(gubun4.equals("12"))%>selected<%%>>������û��</option>					
                    <option value="13" <%if(gubun4.equals("13"))%>selected<%%>>�����Ϸ�</option>					
                    <option value="9" <%if(gubun4.equals("9"))%>selected<%%>>�̵��</option>	
                  </select></td>           
               
        		
        		    </td>
                    <td class=title width=10%>����</td>
                    <td width=40%>&nbsp;
            		    <input type="radio" name="gubun1" value=""  <%if(gubun1.equals(""))%>checked<%%>>
            			��ü
            		    <input type="radio" name="gubun1" value="Y" <%if(gubun1.equals("Y"))%>checked<%%>>
            			��û
            		    <input type="radio" name="gubun1" value="N" <%if(gubun1.equals("N"))%>checked<%%>>
            			�̽�û	
            		    <input type="radio" name="gubun1" value="N" <%if(gubun1.equals("2"))%>checked<%%>>
            			����
						</td> -->		  		  

</form>
</body>
</html>
