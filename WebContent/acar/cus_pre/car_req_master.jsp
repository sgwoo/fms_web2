<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id"); 
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id"); //�����
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id"); 
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd"); //����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	
	

//	String gubun = "Y";
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "01", "01");
		
	String m1_content="";
		
	//��������
	Hashtable res = rs_db.getCarMaintInfo(c_id);	
	
     if (!String.valueOf(res.get("M1_CONTENT")).equals("") && !String.valueOf(res.get("M1_CHK")).equals("")    )  {
          m1_content = String.valueOf(res.get("M1_CONTENT"));         
     } else {
              if ( gubun.equals("Y")) {
               m1_content=" ���ɿ���� �ӽð˻��Ƿ��մϴ�. �ڵ�������� ������ �˻��û���� ���� ��� �����ּ��� - ����� ���漱  Tel)02-6263-6368";
              }         
     }
                     
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//�����ϱ�
	function save(){
		var fm = document.form1;
		if( fm.m1_chk.value == '1' ) {
			alert("����Ÿ�ڵ����� �Ƿ��� �� �����ϴ�. �ٽ� Ȯ���Ͽ� ����ϼ���..!!");
			return;
		}	
		
		if( fm.m1_chk.value == '5' ) {
			alert("������Ƽ�ڸ��ƿ� �Ƿ��� �� �����ϴ�. �ٽ� Ȯ���Ͽ� ����ϼ���..!!");
			return;
		}
		
		if( fm.m1_chk.value == '6' ) {
			alert("�̽��͹ڴ븮�� �Ƿ��� �� �����ϴ�. �ٽ� Ȯ���Ͽ� ����ϼ���..!!");
			return;
		}
		
		if( fm.gubun.value == 'Y'  ) {
		    if (  fm.m1_chk.value == '3' ||   fm.m1_chk.value == '8' ||   fm.m1_chk.value == 'A' ) {
		     }  else {
			alert("�����˻��, ���� , �������� �̿ܿ�  �Ƿ��� �� �����ϴ�. �ٽ� Ȯ���Ͽ� ����ϼ���..!!");
			return;
		     }	
		}			
		
		if( fm.m1_chk.value == '' ) {
			alert("�Ƿڳ����� �����ϼ���..!!");
			return;
		}
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
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
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='car_no' value='<%=car_no%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='mng_id' value='<%=mng_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<table border=0 cellspacing=0 cellpadding=0 width=500>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%> ���� �˻��Ƿ� ���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="25%">�Ƿ�</td>
                    <td>&nbsp;
                    
 <%  if ( !String.valueOf(res.get("M1_CHK")).equals("")    )  {   %>                
                    <SELECT NAME="m1_chk" >                    	
                     			<option value="0" <%if( res.get("M1_CHK").equals("0"))%> selected<%%>>�ش���� ����</option>
                      		   <option value="1" <%if( res.get("M1_CHK").equals("1"))%> selected<%%>>����Ÿ�ڵ��� �˻��Ƿ� ��û</option>   
                    		   <option value="2" <%if( res.get("M1_CHK").equals("2"))%> selected<%%>>����ڰ� ���� �˻�����</option> 
                    		   <option value="3" <%if( res.get("M1_CHK").equals("3"))%> selected<%%>>�����ڵ��� �˻��Ƿ� ��û</option>                     		
                    		   <option value="5" <%if( res.get("M1_CHK").equals("5"))%> selected<%%>>������Ƽ�ڸ��� �˻��Ƿ� ��û</option> 
                    		   <option value="6" <%if( res.get("M1_CHK").equals("6"))%> selected<%%>>�̽��͹ڴ븮 �˻��Ƿ� ��û</option> 
                    		    <option value="8" <%if( res.get("M1_CHK").equals("8"))%> selected<%%>>���� �˻��Ƿ� ��û</option> 
                    		     <option value="A" <%if( res.get("M1_CHK").equals("A"))%> selected<%%>>��������(�뱸) �˻��Ƿ� ��û</option> 
                    		 
        		        </SELECT>
 <% } else { %>       		        
        		           <SELECT NAME="m1_chk" >
                    			<option value="" > --���� -- </option>
                     			<option value="0" > �ش���� ����</option>                      		 
                    		   <option value="2" >����ڰ� ���� �˻�����</option> 
                    		   <option value="3" >�����ڵ��� �˻��Ƿ� ��û</option>   
                    		   <option value="8" >���� �˻��Ƿ� ��û</option>    
                    		   <option value="A" >��������(�뱸) �˻��Ƿ� ��û</option>                  		
                    		 
        		        </SELECT>
<% } %>        		        
        		         <%if( res.get("M1_CHK").equals("1")) {%> �Ƿ��� : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        		         <%if( res.get("M1_CHK").equals("2")) {%> ����� : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        		         <%if( res.get("M1_CHK").equals("3")) {%> �Ƿ��� : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        		         <%if( res.get("M1_CHK").equals("5")) {%> �Ƿ��� : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        		         <%if( res.get("M1_CHK").equals("6")) {%> �Ƿ��� : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        		         <%if( res.get("M1_CHK").equals("8")) {%> �Ƿ��� : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        	        </td>
    		    </tr>	
    		  
    		    <tr> 
                    <td class=title  width="25%" >�䱸����</td>
                    <td colspan="2" >&nbsp; 
                      <textarea name='m1_content' rows='3' cols='60' ><%=m1_content%></textarea>
                    </td>
                </tr>	
                <tr> 
                    <td class=title  width="25%" >���� Ư�̻��� <br> (�����ü)</td>
                    <td colspan="2" >&nbsp; 
                     <textarea name='che_remark' rows='3' cols='60' readonly ><%=(String)res.get("CHE_REMARK") %></textarea>
                    </td>
                </tr>	
                
               
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
         <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>
          <%  if ( String.valueOf(res.get("M1_CHK")).equals("")    )  {   %>                 
        <% //if( !res.get("M1_CHK").equals("1") && !res.get("M1_CHK").equals("2") && !res.get("M1_CHK").equals("3")  && !res.get("M1_CHK").equals("5") ){ %>
        <input type='checkbox' name="sms_yn" value='Y' >�����̿��ڿ��� �ڵ� �ȳ� ���� �߼�
        <a href="javascript:save();"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
        <% } %> 
        <% } %>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
    
    <tr>
    	<td><font color=red>&nbsp;**</font>&nbsp;�����ü��  �˻��Ƿ� ����ϼ���!!! <br>���ɿ��� �ӽð˻�� �켱 �����˻�ҿ����� �����մϴ�. <br>������  ����ڰ� �����մϴ�.<br>
    		    <font color=red>&nbsp;**</font>&nbsp;�����̿��ڰ� �̵�ϵǾ� �ִ� ���  ���ڰ� �߼۵��� �ʽ��ϴ�. �߼��� ���� ��� ��Ͽ��� �ڵ��� �������� ������ �߼��� �� �ֽ��ϴ�!!!
       </td>
    <tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
