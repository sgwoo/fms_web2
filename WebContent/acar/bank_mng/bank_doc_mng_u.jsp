<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*,  acar.user_mng.*,  acar.estimate_mng.*"%>
<%@ page import="acar.partner.*" %>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	Serv_EmpDatabase se_db = Serv_EmpDatabase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	//�����û����Ʈ
	Vector FineList = FineDocDb.getBankDocLists(doc_id);
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//����
	String var1 = e_db.getEstiSikVarCase("1", "", "bank1");//���μ���
	String var2 = e_db.getEstiSikVarCase("1", "", "bank2");	//�����	
	String var3 = e_db.getEstiSikVarCase("1", "", "bank_app1");//÷�μ���1
	String var4 = e_db.getEstiSikVarCase("1", "", "bank_app2");//÷�μ���2
	String var5 = e_db.getEstiSikVarCase("1", "", "bank_app3");//÷�μ���3
	String var6 = e_db.getEstiSikVarCase("1", "", "bank_app4");//÷�μ���4
	String var7 ="";
	if  (Integer.parseInt(FineDocBn.getDoc_dt()) > 20141204) {	
		 var7 = e_db.getEstiSikVarCase("1", "", "bank_app6");//÷�μ���5
	 } else {
		 var7 = e_db.getEstiSikVarCase("1", "", "bank_app5");//÷�μ���5
	} 
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') fine_gov_search();
	}	
	
	
	//��Ϻ���
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "fine_doc_mng_frame.jsp";
		fm.submit();
	}	
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	//�����ϱ�
	function fine_doc_upd(){	
		var fm = document.form1;
		
		if(fm.doc_id.value == '')		{ alert('������ȣ�� Ȯ���Ͻʽÿ�.'); return; }
		if(fm.doc_dt.value == '')		{ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }		
		if(fm.gov_id.value == '')		{ alert('���ű���� �����Ͻʽÿ�.'); return; }		
		if(fm.gov_nm.value == '')		{ alert('���ű���� �����Ͻʽÿ�.'); return; }

		//�Ե����丮���� ���� �����缳���� �Է¹޾ƾ� ��  
		if(fm.gov_id.value == '0093')	{  
			if ( fm.cltr_rat.value  == '') { alert('�����缳���� �Է��Ͻʽÿ�.'); return; }
		}
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = "bank_doc_mng_u_a.jsp";
		fm.target = "i_no";
		fm.submit()
	}		
			
	//�����ϱ�
	function fine_doc_upd1(gubun){	
		var fm = document.form1;
		
		if(fm.doc_id.value == '')		{ alert('������ȣ�� Ȯ���Ͻʽÿ�.'); return; }
		
		if ( gubun == '1') {
			if(!confirm('CMS ����ڵ� �ο��Ͻðڽ��ϱ�?')){	return;	}
		} else if ( gubun == '2') {
				if(fm.app_dt.value == '')		{ alert('ī���Һ� �������ڸ� �Է��Ͻʽÿ�.'); return; }
				if(!confirm('ī���Һ� �������ڸ� �����Ͻðڽ��ϱ�?')){	return;	}	
		}	
	
		fm.action = "bank_doc_mng_u1_a.jsp?gubun="+gubun;
		fm.target = "i_no";
		fm.submit()
	}
	
	
	//������ �����
	function find_emp_search(){
		var fm = document.form1;

		window.open("find_emp_search.jsp?bank_id="+fm.gov_id.value, "SEARCH_FINE_GOV", "left=100, top=100, width=450, height=550, scrollbars=yes");	
		
	}	

//-->
</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > �����ڱݰ��� > <span class=style5>������� ��û���� ����</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td align="right"><!--<a href="javascript:go_list();" onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a>--></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class="line" width="100%"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=15%>������ȣ</td>
                    <td width=85%>&nbsp;&nbsp;<%=FineDocBn.getDoc_id()%></td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp;&nbsp;<input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
                 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                    &nbsp;&nbsp;<input type="text" name="gov_nm" value='<%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%>' size="50" class="text" style='IME-MODE: active' onKeyDown='javascript:enter()' readonly >
    			    <input type='hidden' name="gov_id" value='<%=FineDocBn.getGov_id()%>'>
    			     &nbsp;&nbsp;[��������]
                      <input type="text" name="emp_nm" size="15" readonly  class="whitetext" value="<%=se_db.getServEmpNm(FineDocBn.getOff_id(), FineDocBn.getSeq())%>" style='IME-MODE: active'> 
                      <input type='hidden' name="off_id" value='<%=FineDocBn.getOff_id()%>'>      
                      <input type='hidden' name="seq" value='<%=FineDocBn.getSeq()%>'>    
                       <a href="javascript:find_emp_search();"><img src=../images/center/button_in_search1.gif align=absmiddle border=0></a>
                  
    			    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;&nbsp;<input type="text" name="mng_dept" value='<%=FineDocBn.getMng_dept()%>' size="50" class="text">
    			    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;&nbsp;<input type="text" name="title" value='<%=FineDocBn.getTitle()%>' size="80" class="text"  ></td>
                </tr>
                <tr> 
                    <td class='title' style='height:36'>����</td>
                    <td>&nbsp;&nbsp;1. �� ���� ������ ������ ����մϴ�. <br>
                	    &nbsp;&nbsp;2. �Ʒ��� ���� �ڵ��� ���Կ� �ʿ��� �ڱ��� ��û�Ͽ���, ���� �� �����Ͽ� �ֽʽÿ�.
               
                    </td>
                </tr>		  
                <tr> 
                    <td class='title'>÷��</td>
                    <td>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc1" value="Y" <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var3%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc2" value="Y" <%if(FineDocBn.getApp_doc2().equals("Y"))%>checked<%%>><%=var4%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc3" value="Y" <%if(FineDocBn.getApp_doc3().equals("Y"))%>checked<%%>><%=var5%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc4" value="Y" <%if(FineDocBn.getApp_doc4().equals("Y"))%>checked<%%>><%=var6%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc5" value="Y" <%if(FineDocBn.getApp_doc5().equals("Y"))%>checked<%%>><%=var7%>
                    </td>
                </tr>	
                 <tr> 
                    <td class='title'>�����缳��</td>
                   <td >&nbsp; ������� 
                      <input type="text" name="cltr_rat"  maxlength='5' size="3" value='<%=FineDocBn.getCltr_rat()%>'  class=text>
                      (%)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�Ǵ� �����Ǵ� <input type="text" name="cltr_amt" size="15"  value='<%=FineDocBn.getCltr_amt()%>'  class="num" onBlur='javascript:this.value=parseDecimal(this.value); '>  ��
                    </td>
                </tr>	  
                <tr> 
                    <td class='title'>�����������</td>
                    <td>&nbsp;&nbsp;<input type="text" name="end_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getEnd_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>	 
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp;&nbsp;<input type="text" name="filename" size="5" class="text" value="<%=FineDocBn.getFilename()%>">&nbsp;%</td>
                </tr>	
                <tr> 
                    <td class='title'>��ȯ����</td>
                    <td>&nbsp;&nbsp;<select name="gov_st">
                        <option value="1" <%if(FineDocBn.getGov_st().equals("1"))%>selected<%%>>�����ݱյ�</option>
                        <option value="2" <%if(FineDocBn.getGov_st().equals("2"))%>selected<%%>>���ݱյ�</option>
                    </select>&nbsp;
                   
                    </td>
                </tr>	
                 <% if ( FineDocBn.getCard_yn().equals("Y")){ %>          
                  <tr> 
                    <td class='title'>ī���Һ� ��������</td>
                    <td>&nbsp;&nbsp;<input type="text" name="app_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getApp_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'>             
               
<% if ( user_id.equals("000063") ||   nm_db.getWorkAuthUser("���������",user_id)  ) {%>                   
                     <a href="javascript:fine_doc_upd1('2');"><img src=../images/center/button_modify.gif align=absmiddle border=0></a>
 <% } %>            
                   </td>
                </tr>	  		  
               <%} %> 
                  		  
               
                 <tr> 
                    <td class='title'>CMS����ڵ�</td>
                   <td>&nbsp;&nbsp;                   
                      <select name="cms_code">
				    <option value='' <%if(FineDocBn.getCms_code().equals(""))%>selected<%%>>����</option>
				    <option value='9951572587'  <%if(FineDocBn.getCms_code().equals("9951572587"))%>selected<%%>>9951572587 (����:amazoncar1)</option>             
			        <option value='9950110252'  <%if(FineDocBn.getCms_code().equals("9950110252"))%>selected<%%>>9950110252 (��ȯ:amazoncar2)</option>              
			        <option value='9954513141'  <%if(FineDocBn.getCms_code().equals("9954513141"))%>selected<%%>>9954513141 (���:amazoncar3)</option>    
			        <option value='9950110401'  <%if(FineDocBn.getCms_code().equals("9950110401"))%>selected<%%>>9950110401 (����:amazoncar4)</option> 
			        <option value='9954516981'  <%if(FineDocBn.getCms_code().equals("9954516981"))%>selected<%%>>9954516981 (���:amazoncar6)</option>     
			        <option value='9954517597'  <%if(FineDocBn.getCms_code().equals("9954517597"))%>selected<%%>>9954517597 (�츮:amazoncar7)</option>  
			        <option value='9954519858'  <%if(FineDocBn.getCms_code().equals("9954519858"))%>selected<%%>>9954519858 (����:amazoncar8)</option>  
			        <option value='9950110418'  <%if(FineDocBn.getCms_code().equals("9950110418"))%>selected<%%>>9950110418 (�ϳ�:amazoncar5)(���x)</option>                                                                  
	              </select>	                   
               
<% if ( user_id.equals("000063") ||  nm_db.getWorkAuthUser("CMS����",user_id) ||  nm_db.getWorkAuthUser("��ݴ��",user_id)  ) {%>                   
                     <a href="javascript:fine_doc_upd1('1');"><img src=../images/center/button_modify.gif align=absmiddle border=0></a>
 <% } %>
             
                   </td>
                </tr>	  		  
                
            </table>
        </td>
    </tr>    
    <tr> 
        <td align="right">
	    <%if(FineDocBn.getPrint_dt().equals("")){%>
	    <%}else{%>
	    <img src=../images/center/arrow_printd.gif align=absmiddle> : <%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%>&nbsp;&nbsp;
	    <%}%>
	    <a href="javascript:fine_doc_upd();"><img src=../images/center/button_modify.gif align=absmiddle border=0></a>
	    &nbsp;<a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a>	  
	    </td>
    </tr>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
