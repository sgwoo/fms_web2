<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();


	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");

   	// ������� ���޿�û���� �Ѿ��� ��� - 202104
   	String card = request.getParameter("card")==null?"":request.getParameter("card");	
	String gov_id = request.getParameter("gov_id")==null?"0011":request.getParameter("gov_id");
	String gov_nm = "";
	
	if(card.equals("Y") && gov_id.equals("")){
		//�츮ī�� 0046
		//20220617 ����ĳ��Ż 0011
		gov_id = "0011";
	}
	
	if(card.equals("Y") && !gov_id.equals("")){
		gov_nm = c_db.getNameByIdCode("0003", gov_id, "");
	}
	
	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "HEAD", "Y");
	int user_size = users.size();
	Vector users2 = c_db.getUserList("", "", "BODY", "Y");
	int user_size2 = users2.size();	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//����
	String var1 = e_db.getEstiSikVarCase("1", "", "bank1");//���μ���
	String var2 = e_db.getEstiSikVarCase("1", "", "bank2");	//�����	
	String var3 = e_db.getEstiSikVarCase("1", "", "bank_app1");//÷�μ���1
	String var4 = e_db.getEstiSikVarCase("1", "", "bank_app2");//÷�μ���2
	String var5 = e_db.getEstiSikVarCase("1", "", "bank_app3");//÷�μ���3
	String var6 = e_db.getEstiSikVarCase("1", "", "bank_app4");//÷�μ���4
         String var7 ="";
         
//         out.println( Integer.parseInt(AddUtil.getDate(4) ));
         
         if  (Integer.parseInt(AddUtil.getDate(4)) > 20141204) {	
		 var7 = e_db.getEstiSikVarCase("1", "", "bank_app6");//÷�μ���5
	 } else {
		 var7 = e_db.getEstiSikVarCase("1", "", "bank_app5");//÷�μ���5
	} 
            

   		   	
 	String[] chk_cd = request.getParameterValues("ch_cd");
 	
   	String vid_num="";
   	
   	String ch_est_amt ="";  
   	String ch_est_dt ="";  
   	String ch_mng_id ="";
   	String ch_l_cd ="";
   	 
         
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	

	//����ó�˻��ϱ�
	function find_bank_search(){
		var fm = document.form1;	
		window.open("find_bank_search.jsp?t_wd="+fm.bank_nm.value, "SEARCH_FINE_GOV", "left=100, top=100, width=450, height=550, scrollbars=yes");
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') find_bank_search();
	}	
	
	//
	function find_cont_search(){
		var fm = document.form1;
		if(fm.bank_nm.value == '') { alert('�����縦 Ȯ���Ͻʽÿ�.'); return; }
		window.open("find_cont_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&bank_id="+fm.bank_id.value+"&t_wd="+fm.bank_nm.value, "SEARCH_FINE", "left=50, top=50, width=1000, height=700, scrollbars=no");
	}
	
	//������ ����� 
	function find_emp_search(){
		var fm = document.form1;

		window.open("find_emp_search.jsp?bank_id="+fm.bank_id.value, "SEARCH_FINE_GOV", "left=100, top=100, width=450, height=550, scrollbars=yes");	
		
	}	
	
	//��� - ����������޿��� �Ѿ���� �� ó���� 
	function save()
	{
		var fm = document.form1;	
		
		if(fm.bank_id.value == '')	{	alert('����ó�� �Է��Ͻʽÿ�.'); 	fm.doc_dt.focus(); 		return; }
				
		if(confirm('����Ͻðڽ��ϱ�?')){					
			fm.action='bank_doc_reg_sc1_a.jsp';		
			fm.target='i_no';
			//fm.target='_blank';			
			fm.submit();
		}
	}
		
//-->
</script>
</head>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onload="javascript:document.form1.bank_nm.focus()" leftmargin=15>
<form name='form1' action='bank_doc_reg_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='card' value='<%=card%>'>
<%	
if (chk_cd != null){
  	//�Ľ�
	for(int i=0; i< chk_cd.length;i++){
		vid_num=chk_cd[i];	
		vid_num = vid_num.substring(0, vid_num.length()-1);	
		
		StringTokenizer token1 = new StringTokenizer(vid_num,"/");
				
		while(token1.hasMoreTokens()) {				
				ch_est_amt = token1.nextToken().trim();	
				ch_est_dt = token1.nextToken().trim();		
				ch_mng_id = token1.nextToken().trim();	 
				ch_l_cd = token1.nextToken().trim();
				
		}	
		
%>
  <input type="hidden" name="ch_mng_id" value="<%=ch_mng_id%>">
  <input type="hidden" name="ch_l_cd" value="<%=ch_l_cd%>">
    
<%	}%>
<%}%>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > �����ڱݰ��� > <span class=style5>�����û �����ۼ����</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=12%>������ȣ</td>
                    <td width=88%>&nbsp;  
                      <input type="text" name="doc_id" size="15" class="text" value="<%=FineDocDb.getFineGovNoNext("�ѹ�")%>">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp; 
                      <input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
                    &nbsp;&nbsp;&nbsp;&nbsp;[�ڱ�]&nbsp;<select name="fund_yn">
                        <option value="" selected>����</option>             
                        <option value="Y" >����</option>                   
                    </select>&nbsp;
                    
                    
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;  
       <% if ( card.equals("Y")) { %>    
                 <input type="text" name="bank_nm" size="50" class="text" value="<%=gov_nm %>" style='IME-MODE: active' onKeyDown="javasript:enter()"> 
        		 <input type='hidden' name="bank_id" value='<%=gov_id %>'> 
       <% } else { %>
	              <input type="text" name="bank_nm" size="50" class="text" value="" style='IME-MODE: active' onKeyDown="javasript:enter()"> 
        		  <input type='hidden' name="bank_id" value=''>
       <% } %> 			  
                      <a href="javascript:find_bank_search();"><img src=../images/center/button_in_search1.gif align=absmiddle border=0></a>
                      &nbsp;&nbsp;[��������]
                      <input type="text" name="emp_nm" size="15" readonly  class="whitetext" value="" style='IME-MODE: active'> 
                      <input type='hidden' name="off_id" value=''>    
                      <input type='hidden' name="seq" value=''>    
                       <a href="javascript:find_emp_search();"><img src=../images/center/button_in_search1.gif align=absmiddle border=0></a>
        			</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;  
                      <input type="text" name="mng_dept" size="50" class="text"> 
                       <input type="hidden" name="mng_nm" size="50" class="text"> 
                        <input type="hidden" name="mng_pos" size="50" class="text"> 
                     </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;  
                     <input type="text" name="title" size="80" class="text"  value='�ڵ��� ���Կ� �ʿ��� �ڱ��� ���� ��û' > 
                   </td>
                </tr>
                <tr> 
                    <td class='title' style='height:38'>����</td>
                    <td> &nbsp; 1. �� ���� ������ ������ ����մϴ�. <br>
                    &nbsp; 2. �Ʒ��� ���� �ڵ��� ���Կ� �ʿ��� �ڱ��� ��û�Ͽ���, ���� �� �����Ͽ� �ֽʽÿ�.        
                     </td>
                </tr>
                <tr> 
                    <td class='title'>÷��</td>
                    <td>
        			<input type="checkbox" name="app_doc1" value="Y" checked><%=var3%><br>
        			<input type="checkbox" name="app_doc2" value="Y" checked><%=var4%><br>
        			<input type="checkbox" name="app_doc3" value="Y" checked><%=var5%><br>
        			<input type="checkbox" name="app_doc4" value="Y" checked><%=var6%><br>
        			<input type="checkbox" name="app_doc5" value="Y" checked><%=var7%>
                    </td>
                </tr>	
                 <tr> 
                    <td class='title'>�����缳��</td>
                   <td >&nbsp; ������� 
                      <input type="text" name="cltr_rat"  maxlength='5' size="3" class=text>
                      (%)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�Ǵ� �����Ǵ� <input type="text" name="cltr_amt" size="15" class="num" onBlur='javascript:this.value=parseDecimal(this.value); '>  ��
                    </td>
                </tr>	  
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>       
    <tr><td class=line2></td></tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width=12% class='title'>���μ���</td>
                    <td width=38%>&nbsp; <select name='h_mng_id'>
                    <option value="">����</option>
                    <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                    <option value='<%=user.get("USER_ID")%>' <%if(var1.equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                    <%		}
        					}		%>
                    </select></td>
                    <td width=12% class='title'>�����</td>
                    <td width=38%>&nbsp; <select name='b_mng_id'>
                    <option value="">����</option>
                    <%	if(user_size2 > 0){
        						for (int i = 0 ; i < user_size2 ; i++){
        							Hashtable user = (Hashtable)users2.elementAt(i);	%>
                    <option value='<%=user.get("USER_ID")%>' <%if(var2.equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                    <%		}
        					}		%>
                    </select></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    
    <tr> 
        <td>&nbsp;        
   <% if ( card.equals("Y")) { %>     <!-- ������� ���޿�û���� �Ѿ���� ��� ó�� --> 	  
      		<a href="javascript:save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
   <% } else { %>
   			<a href="javascript:find_cont_search();"><img src=/acar/images/center/button_search_gy.gif border=0 align=absmiddle></a>
   <% }  %>	
      	</td>
    </tr> 
    
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>  
</body>
</html>
