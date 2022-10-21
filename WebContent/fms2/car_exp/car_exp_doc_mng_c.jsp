<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
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
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
	
	//���·Ḯ��Ʈ
	Vector FineList = FineDocDb.getFineDocListsCar_exp(doc_id);
	int fine_size = FineList.size();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "HEAD", "Y");
	int user_size = users.size();
	Vector users2 = c_db.getUserList("", "", "BODY", "Y");
	int user_size2 = users2.size();
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//����
	String var1 = e_db.getEstiSikVarCase("1", "", "fine1");//���μ���
	String var2 = e_db.getEstiSikVarCase("1", "", "fine2");	//�����	
	String var3 = e_db.getEstiSikVarCase("1", "", "fine_app1");//÷�μ���1
	String var4 = e_db.getEstiSikVarCase("1", "", "fine_app2");//÷�μ���2
	String var5 = e_db.getEstiSikVarCase("1", "", "fine_app3");//÷�μ���3
	String var6 = e_db.getEstiSikVarCase("1", "", "fine_app4");//÷�μ���4
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//���ǽ�û�����
	function ObjectionPrint(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=750, height=600, resizable=yes, scrollbars=yes, status=yes");			
	}
	//���ű�� ���� 
	function view_fine_gov(gov_id){
		window.open("../fine_doc_reg/fine_gov_c.jsp?gov_id="+gov_id, "view_FINE_GOV", "left=200, top=200, width=560, height=150, resizable=yes, scrollbars=yes, status=yes");
	}
	//����ϱ�
	function FineDocPrint(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="car_exp_doc_print.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, resizable=yes, scrollbars=yes, status=yes");			
	}
	//��Ϻ���
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "car_exp_mng_frame.jsp";
		fm.submit();
	}			
	//�����ϱ�
	function fine_update(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "car_exp_doc_mng_u.jsp";
		fm.submit();
	}	
	
	//�����ϱ�
	function fine_upd(){
		window.open("fine_doc_mng_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>", "REG_FINE_GOV", "left=100, top=200, width=860, height=400, resizable=yes, scrollbars=yes, status=yes");
	}
		
	//����Ʈ�����ϱ�
	function list_save(doc_id, car_mng_id, seq_no){
		window.open("fine_doc_list_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&car_mng_id="+car_mng_id+"&seq_no="+seq_no, "REG_FINE_LIST", "left=100, top=200, width=860, height=400, resizable=yes, scrollbars=yes, status=yes");
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			

		//�����ϱ�
	function fine_del(){
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.target = "d_content";
		fm.action = "car_exp_doc_mng_d_a.jsp";
		fm.submit();
	}
	//�޾ȳ����Ϲ߼�
	function doc_email(){
	   
		var fm = document.form1;
			
		if(confirm('������ �߼��ϰڽ��ϱ�?')){	
			fm.action="cont_cancel_doc_mail_a.jsp";			
			fm.target='i_no';
			fm.submit();
		}											
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
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='start_num' value=''>
<input type='hidden' name='end_num' value=''>
<input type='hidden' name='gov_nm' value='<%=FineDocBn.getGov_nm()%>'>
<input type='hidden' name='doc_title' value='<%=FineDocBn.getTitle()%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > �ڵ�����ȯ�ް����߼� > <span class=style5>���ǽ�û��������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>    
        <td align="right" >
		  <%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",user_id)){%>
		   <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  	 	  <a href="javascript:fine_del();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif"  align="absmiddle" border="0"></a>&nbsp;
			<%}%>
		  <%}%>
			  <a href="javascript:go_list();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif"  align="absmiddle" border="0"></a>
		 </td>
			  
         
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line" width="100%"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=13%>������ȣ</td>
                    <td width=87%>&nbsp;<%=FineDocBn.getDoc_id()%></td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp;<%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;<a href="javascript:view_fine_gov('<%=FineGovBn.getGov_id()%>');" onMouseOver="window.status=''; return true"><%=FineGovBn.getGov_nm()%></a></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;<%=FineDocBn.getMng_dept()%> 
        			<%if(!FineDocBn.getMng_nm().equals("")){%>						
        			(����� : <%=FineDocBn.getMng_nm()%> <%=FineDocBn.getMng_pos()%>) 
        			<%}%>						
        			</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;�ڵ����� ȯ�޽�û�� ����</td>
                </tr>
				<%if(FineGovBn.getGov_nm().equals("���￵������û")){%>
				<tr> 
				<td class='title'>ȯ�޸���</td>
				<td colspan=3>&nbsp;�����ּ� : <input type='text' name='email' size='30' value='kimida82@ydp.go.kr' class='text'>&nbsp;
					<a href="javascript:doc_email()"><img src="/acar/images/center/button_in_s.gif" align="absmiddle" border="0"></a> (�ؼ���(��������û) ��û�ÿ��� ���Ϲ߼���! )
				</td>
				</tr>	  
				<%}%>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;�� 
                    <%=FineDocBn.getGov_st()%>
                    �� ������ ������ ����մϴ�. </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr>     
        <td></td>    
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>
    <tr>     
        <td class=line2></td>    
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width=13% class='title'>���μ���</td>
                    <td width=37%><select name='h_mng_id' disabled>
                        <option value="">����</option>
                        <%	if(user_size > 0){
            						for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getH_mng_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                        </select></td>
                    <td  width=13% class='title'>�����</td>
                    <td width=37%><select name='b_mng_id' disabled>
                        <option value="">����</option>
                        <%	if(user_size2 > 0){
            						for (int i = 0 ; i < user_size2 ; i++){
            							Hashtable user = (Hashtable)users2.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getB_mng_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                        </select></td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr> 
        <td align="right">
    	  <%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",user_id)){%>
    	  <%if(FineDocBn.getPrint_dt().equals("")){%>
    	  <a href="javascript:FineDocPrint();"><img src=/acar/images/center/button_print_gm.gif align=absmiddle border=0></a>&nbsp;&nbsp;
    	  <%}else{%>
    	  <img src=/acar/images/center/arrow_printd.gif align=absmiddle> : <a href="javascript:FineDocPrint();"><%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%> (<%=c_db.getNameById(FineDocBn.getPrint_id(), "USER")%>)</a>&nbsp;&nbsp;
    	  <%}%>	  
    	  <%if(FineGovBn.getGov_nm().indexOf("��û") != -1){%>
    	  <a href="javascript:ObjectionPrint();"><img src=/acar/images/center/button_iiscs.gif align=absmiddle border=0></a>
    	  <%}%>
    	  <%}%>
	    </td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ����� ȯ�޽�û ����Ʈ</span> 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr bgcolor="#A6FFFF" align="center"> 
					<td class="title" width="5%" height="30" rowspan="3">����</td>
					<td class="title" width="10%" rowspan="3"><font face="����" >������ȣ</td>
					<td class="title" width="15%" rowspan="3">����</td>
					<td class="title" width="15%" align="center" bgcolor="#A6FFFF"  rowspan="3">�ڵ�����������</td>
					<td class="title" width="55%" colspan="3" height="10">ȯ�޽�û����</td>
				</tr>
				<tr>
					<td class="title" width="30%" align="center"  height="10" bgcolor="#A6FFFF" colspan="2">�����ں���</td>
					<td class="title" width="25%" align="center"  height="10" bgcolor="#A6FFFF" rowspan="2">�뵵����</td>
				</tr>
				<tr>
					<td class="title" width="20%" align="center" bgcolor="#A6FFFF">������</td>
					<td class="title" width="10%" align="center" bgcolor="#A6FFFF">��������</td>
					
				</tr>
              <% if(FineList.size()>0){
					for(int i=0; i<fine_size; i++){ 
						Hashtable ht = (Hashtable)FineList.elementAt(i);		%>
				<tr bgcolor="#FFFFFF" align="center">
					<td width="5%" height="25" bgcolor="#FFFFFF" style="font-size : 8pt;"><%=i+1%></td>
					<td width="10%" style="font-size : 8pt;"><%=ht.get("CAR_NO")%></td>
					<td width="15%" style="font-size : 8pt;"><%=ht.get("CAR_NM")%></td>
					<td width="15%" style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXP_DT")))%></td>
					<td width="20%" style="font-size : 8pt;"><%=ht.get("FIRM_NM")%></td>
					<td width="10%" style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIGR_DT")))%></td>
					<td width="25%" style="font-size : 8pt;"><%=ht.get("CHA_CONT")%></td>
					
				</tr>
				<% 	}
					}	 %>
            </table>
        </td> 
    </tr>
</table>
</form>
</body>
</html>
