<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.settle_acc.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String today = request.getParameter("today")==null?AddUtil.getDate():request.getParameter("today");
	
	//�α���ID
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	//�α���-�뿩����:����
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 7; //��Ȳ ��� �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	if(AddUtil.parseInt(s_height)==800) height = height+180;
	if(AddUtil.parseInt(s_height)==768) height = height+148;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script>
	function view_memo(m_id, l_cd)
	{
		var auth_rw = document.form1.auth_rw.value;		

		//�ܱ�뿩(����Ʈ)
		if(m_id == '' && l_cd.length ==6){
			var SUBWIN="/acar/con_rent/res_memo_i.jsp?s_cd="+l_cd+"&c_id=&user_id=<%=ck_acar_id%>";	
			window.open(SUBWIN, "RentMemoDisp", "left=100, top=100, width=580, height=700, scrollbars=yes");					
		//���뿩
		}else{
			window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
		}
	}
	
	//���� ���γ��� ����
	function view_settle(mode, m_id, l_cd, client_id, c_id, gubun3){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;		
		fm.client_id.value = client_id;
		fm.target = "d_content";		
		if(mode=='cont' && l_cd.length == 6){
			fm.mode.value = "client";
		}else{
			fm.mode.value = mode;				
		}

		if(gubun3 == '�����뿩'){			
			fm.action = "/acar/settle_acc/settle_c.jsp";		
			fm.submit();
		}else{
			fm.action = "/acar/settle_acc/settle_c.jsp";					
			fm.submit();
		}
	}

	//�ߵ���������  ����
	function view_settle_doc(m_id, l_cd, use_yn){
	  	if (use_yn == 'Y' ) {
	  	
			window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");		
		} else {
			window.open("/acar/cls_con/cls_u1.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SETTLE1", "left=100, top=10, width=840, height=650, scrollbars=yes, status=yes");		
		
		}	
	}	

	//��������߼ۿ�û �̷º���
	function view_credit_req(){
		window.open("settle_acc_doc_req_list.jsp?user_id=<%=user_id%>", "VIEW_CREDIT_REQ_H", "left=10, top=10, width=1000, height=650, scrollbars=yes, status=yes");
	}	
	
	//��������߼ۿ�û
	function select_credit_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var j=0;
		
		var use_yn ="";
		var chk_yn ="";
		var result ="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){
				if(ck.checked == true){
					if(ck.name=="")
					idnum=ck.value;
					use_yn = document.inner.document.getElementById("use_yn"+j).value;
					if(!chk_yn){
						chk_yn = use_yn;
					}else{
						if(chk_yn != use_yn){
							result = "������� ���� ������ ����� �ѹ��� ��û�� �� �����ϴ�." 			
						}
					}
					cnt++;					
				}
			j++;
			}
		}
		
		document.inner.document.getElementById("chk_yn").value = chk_yn;
		
		//������� ���� ������ ����� �ѹ��� ��û�Ҽ� �����ϴ�.
		if(result){
			alert(result);
			return;
		}
		
		if(cnt == 0){
		 	alert("1���̻� �����ϼ���.");
			return;
		}	
		
		if(!confirm('��������߼ۿ�û �Ͻʰڽ��ϱ�? \n\n�˾��� ���������� ��ະ �ּ�����, ���, �ְ�������, �����Ⱓ ���� �Է��ϸ� ä�Ǵ���ڿ��� �޽����� ���ϴ�.')){	return;	}		
		
		fm.target = "_blank";
		fm.action = "settle_acc_doc_req.jsp";
		fm.submit();	
	}					
	
	//ä���߽��Ƿڿ�û
	function select_collect_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					if(fm.cng_yn[idnum.substr(19)].value == 'N'){
						var list_num = toInt(idnum.substr(19))+1;
						alert(list_num+'���� ä���߽� ����� �ƴմϴ�.');
						ck.checked = false;
					}else{
						cnt++;
					}					
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("1���̻� �����ϼ���.");
			return;
		}	
		
		if(!confirm('ä���߽��Ƿڿ�û�ϸ� ä�Ǵ���ڿ��� ä���߽��� ��û�Ǹ�,\n\n��������� �ѹ��� ä�Ǵ���ڿ��� �Ѿ�ϴ�. ��û�Ͻðڽ��ϱ�?')){	return;	}		
		
		fm.target = "i_no";
		fm.action = "settle_acc_cng_req_a.jsp";
		fm.submit();	
	}			
	
	//ä�����ּ���ȸ��û
	function select_addr_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var j=0;
		
		var use_yn ="";
		var chk_yn ="";
		var result ="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){
				if(ck.checked == true){
					if(ck.name=="")
					idnum=ck.value;
					use_yn = document.inner.document.getElementById("use_yn"+j).value;
					if(!chk_yn){
						chk_yn = use_yn;
					}else{
						if(chk_yn != use_yn){
							result = "������� ���� ������ ����� �ѹ��� ��û�� �� �����ϴ�." 			
						}
					}
					cnt++;					
				}
			j++;
			}
		}
		
		document.inner.document.getElementById("chk_yn").value = chk_yn;
		
		//������� ���� ������ ����� �ѹ��� ��û�Ҽ� �����ϴ�.
		if(result){
			alert(result);
			return;
		}
		
		if(cnt == 0){
		 	alert("1���̻� �����ϼ���.");
			return;
		}	
		//�ź����� �ּҷ� �������� ������ �ݼ��� �� �̷��� �־�߸� ��ȸ���� �� - 2021-02-09
		if(!confirm('ä�����ּ���ȸ��û �Ͻðڽ��ϱ�? \n\n�˾��� ���������� ��ະ �ּ�����, ���, �ְ�������, �����Ⱓ ���� �Է��ϸ� ä�Ǵ���ڿ��� �޽����� ���ϴ�.')){	return;	}		
		
		fm.target = "_blank";
		fm.action = "settle_acc_addr_req.jsp";
		fm.submit();	
	}					
	//����������ɽ�û��û
	function select_stop_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var j=0;
		
		var use_yn ="";
		var chk_yn ="";
		var result ="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){
				if(ck.checked == true){
					if(ck.name=="")
					idnum=ck.value;
					use_yn = document.inner.document.getElementById("use_yn"+j).value;
					if(!chk_yn){
						chk_yn = use_yn;
					}else{
						if(chk_yn != use_yn){
							result = "������� ���� ������ ����� �ѹ��� ��û�� �� �����ϴ�." 			
						}
					}
					cnt++;					
				}
			j++;
			}
		}
		
		document.inner.document.getElementById("chk_yn").value = chk_yn;
		
		//������� ���� ������ ����� �ѹ��� ��û�Ҽ� �����ϴ�.
		if(result){
			alert(result);
			return;
		}
		
		if(cnt == 0){
		 	alert("1���̻� �����ϼ���.");
			return;
		}	
		
		if(!confirm('����������ɽ�û��û �Ͻʰڽ��ϱ�? \n\n�˾��� ���������� ��ະ �ּ�����, ���, �ְ�������, �����Ⱓ ���� �Է��ϸ� ä�Ǵ���ڿ��� �޽����� ���ϴ�.')){	return;	}		
		
		fm.target = "_blank";
		fm.action = "settle_acc_stop_req.jsp";
		fm.submit();	
	}					
	
	
	//ä�Ǵ��ó����û
	function select_bad_debt_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					if(fm.bad_yn[idnum.substr(19)].value == 'N'){
						var list_num = toInt(idnum.substr(19))+1;
						alert(list_num+'���� ä�� ���ó����û ����� �ƴմϴ�.');
						ck.checked = false;
					}else{
						cnt++;
					}					
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("������ ���� �����ϴ�.");
			return;
		}	
		if(cnt > 1){
		 	alert("1�Ǹ� �����ϼ���.");
			return;
		}	
		
//		if(!confirm('ä�� ���ó����û�ϸ� ���� �ѹ�������������忡�� ���ó���� ��û�Ǹ�,\n\n��������� ����˴ϴ�. ��û�Ͻðڽ��ϱ�?')){	return;	}		
		
		fm.target = "d_content";
		fm.action = "settle_acc_bad_debt_doc_i.jsp";
		fm.submit();	
	}						
	
	//�Ҿ�ä�Ǵ��ó����û
	function settle_acc_bad_debt_req(req_st, m_id, l_cd, cls_use_mon, bad_amt, c_id, s_cd){
		var fm = document.form1;
		
		if(req_st != ''){
			if(!confirm('ä�Ǵ�տ�û ���ϰ��Դϴ�. �ٽ� ��û�Ͻðڽ��ϱ�?')){	return;	}		
		} 
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.cls_use_mon.value = cls_use_mon;
		fm.bad_amt.value = bad_amt;
		fm.c_id.value = c_id;
		fm.s_cd.value = s_cd;
		fm.page_st.value = 'settle_acc';
		fm.target = "d_content";		
		fm.action = "/fms2/settle_acc/bad_debt_doc.jsp";
		fm.submit();
	}
		
	//�����������û
	function settle_acc_bad_complaint_req(client_id){
		var fm = document.form1;
		fm.client_id.value = client_id;
		fm.page_st.value = 'settle_acc';
		fm.target = "d_content";		
		fm.action = "/fms2/settle_acc/bad_complaint_doc.jsp";
		fm.submit();
	}

	//�����������û	
	function select_complaint_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var o_client_id="";		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					
					if(toInt(fm.fee_dly_mon[idnum.substr(19)].value) < 3){
						var list_num = toInt(idnum.substr(19))+1;
						alert(list_num+'���� �����������û ����� �ƴմϴ�.');
						ck.checked = false;
					}else{
						if(cnt > 0 && o_client_id != fm.client_id[idnum.substr(19)].value){							
							alert('���� ���� ���� ��û�Ҽ� �ֽ��ϴ�.');
							return;							
						}else{
							cnt++;
						}
					}
					o_client_id = fm.client_id[idnum.substr(19)].value;
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("1���̻� �����ϼ���.");
			return;
		}	
		
		fm.o_client_id.value = o_client_id;		
		fm.target = "d_content";		
		fm.action = "/fms2/settle_acc/bad_complaint_doc.jsp";
		fm.submit();	
	}
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='s_cd' value=''>
<input type='hidden' name='client_id' value=''>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='cls_use_mon' value=''>
<input type='hidden' name='bad_amt' value=''>
<input type='hidden' name='page_st' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='today' value='<%=today%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='s_height' value='<%=s_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
		        <tr>
    				<td align='center'>
    				  <iframe src="/acar/settle_acc/settle_sc_in.jsp?auth_rw=<%=auth_rw%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="inner" width="100%" height="<%=height - 10%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
    				  </iframe>
    				</td>
		        </tr>
	        </table>
        </td>
    </tr>
    <tr>
        <td>
		<a href="javascript:select_credit_req();" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='��������߼ۿ�û'><img src="/acar/images/center/button_yc_nyjmbs.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;
		<a href="javascript:select_collect_req();" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='ä���߽��Ƿڿ�û'><img src="/acar/images/center/button_ask_cgcs.gif" align="absmiddle" border="0"></a>					
		&nbsp;&nbsp;
		<a href="javascript:select_addr_req();" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='ä�����ּ���ȸ��û'><img src="/acar/images/center/button_ask_add.png" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;
		<a href="javascript:select_stop_req();" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='����������ɿ�û'><img src="/acar/images/center/button_ask_stop.png" align="absmiddle" border="0"></a>
		&nbsp;(ä�Ǵ���ڿ��� ���������� ��ϵǸ�, �޼������� �߼۵˴ϴ�. <a href="javascript:view_credit_req()" title="�̷�"><img src=/acar/images/center/button_in_ir.gif align=absmiddle border=0></a>)
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>      		
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" class='title' align="center">����</td>
                    <td colspan="2" class='title' align="center">�հ�</td>
                    <td colspan="2" class='title' align="center">������</td>
                    <td colspan="2" class='title' align="center">�뿩��</td>
                    <td colspan="2" class='title' align="center">��ü����</td>					
                    <td colspan="2" class='title' align="center">���·�</td>
                    <td colspan="2" class='title' align="center">��å��</td>
                    <td colspan="2" class='title' align="center">��/������</td>
                    <td colspan="2" class='title' align="center">���������</td>
                    <td colspan="2" class='title' align="center">�ܱ���</td>			
                </tr>
                <tr align="center"> 
                    <td class='title'>�Ǽ�</td>
                    <td class='title'>�ݾ�</td>
                    <td class='title'>�Ǽ�</td>
                    <td class='title'>�ݾ�</td>
                    <td class='title'>�Ǽ�</td>
                    <td class='title'>�ݾ�</td>
                    <td class='title'>�Ǽ�</td>
                    <td class='title'>�ݾ�</td>
                    <td class='title'>�Ǽ�</td>
                    <td class='title'>�ݾ�</td>
                    <td class='title'>�Ǽ�</td>
                    <td class='title'>�ݾ�</td>
                    <td class='title'>�Ǽ�</td>
                    <td class='title'>�ݾ�</td>
                    <td class='title'>�Ǽ�</td>
                    <td class='title'>�ݾ�</td>
                    <td class='title'>�Ǽ�</td>
                    <td class='title'>�ݾ�</td>
                </tr>
                <tr> 
                    <td rowspan="2" class='title'>����</td>				
                    <td rowspan="2" align="right"><input type="text" name="cnt" size="2" class="whitenum2">��&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="amt" size="10" class="whitenum2">��&nbsp;</td>
                    <td align="right"><input type="text" name="cnt" size="1" class="whitenum2">��&nbsp;</td>
                    <td align="right"><input type="text" name="amt" size="8" class="whitenum2">��&nbsp;</td>
                    <td align="right"><input type="text" name="cnt" size="2" class="whitenum2">��&nbsp;</td>
                    <td align="right"><input type="text" name="amt" size="10" class="whitenum2">��&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="cnt" size="2" class="whitenum2">��&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="amt" size="10" class="whitenum2">��&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="cnt" size="2" class="whitenum2">��&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="amt" size="7" class="whitenum2">��&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="cnt" size="2" class="whitenum2">��&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="amt" size="9" class="whitenum2">��&nbsp;</td>
                    <td align="right"><input type="text" name="cnt" size="1" class="whitenum2">��&nbsp;</td>
                    <td align="right"><input type="text" name="amt" size="9" class="whitenum2">��&nbsp;</td>
                    <td align="right"><input type="text" name="cnt" size="2" class="whitenum2">��&nbsp;</td>
                    <td align="right"><input type="text" name="amt" size="10" class="whitenum2">��&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="cnt" size="1" class="whitenum2">��&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="amt" size="8" class="whitenum2">��&nbsp;</td>
                </tr>
                <tr>
                  <td align="right"><input type="text" name="e_cnt" size="2" class="whitenum2">��&nbsp;</td>
                  <td align="right"><input type="text" name="e_amt" size="10" class="whitenum2">��&nbsp;<br>(�°������)</td>
                  <td align="right"><input type="text" name="in_cnt" size="2" class="whitenum2">��&nbsp;</td>
                  <td align="right"><input type="text" name="in_amt" size="10" class="whitenum2">��&nbsp;<br>(ȸ��)</td>
                  <td align="right"><input type="text" name="h_cnt" size="2" class="whitenum2">��&nbsp;</td>
                  <td align="right"><input type="text" name="h_amt" size="10" class="whitenum2">��&nbsp;<br>(�氨)</td>
                  <td align="right"><input type="text" name="g_cnt" size="2" class="whitenum2">��&nbsp;</td>
                  <td align="right"><input type="text" name="g_amt" size="10" class="whitenum2">��&nbsp;<br>(����)</td>
                </tr>
                <tr>
				  <td class='title'>�ݿ�</td>		
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="10" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="1" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="8" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="10" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="10" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="7" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="9" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="1" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="9" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="10" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="1" class="isnum2">��&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="8" class="isnum2">��&nbsp;</td>
                </tr>
                <tr>
                  <td class='title'>���</td>
                  <td colspan="2" align="right">&nbsp;</td>
                  <td colspan="2" align="center" style='font-size:8pt'>100%<br>�°������*3��ݿ�</td>
                  <td colspan="2" align="center" style='font-size:8pt'>ȸ�������� ä��10% �ݿ�<br>��û���� 3�ϰ������ �ݿ�<br>����Ʈ �������� ����</td>
                  <td colspan="2" align="center" style='font-size:8pt'>100%</td>				  
                  <td colspan="2" align="center" style='font-size:8pt'>100%</td>
                  <td colspan="2" align="center" style='font-size:8pt'>100%</td>
                  <td colspan="2" align="center" style='font-size:8pt'><!--û����+5�ϱ��� �氨<br>�Ա���+10�ϱ��� �氨<br>���Աݽ� �ִ�30�Ϲݿ�-->�Ա���+1����<br>1��50%/2��25%�氨�ݿ�</td>
                  <td colspan="2" align="center" style='font-size:8pt'>��������û���� �氨<br>100��������100%<br>�ʰ���100����+�ʰ�20%�ݿ�</td>
                  <td colspan="2" align="center" style='font-size:8pt'>��ȸ ���ʿ���100%<br>�׿� ���ʿ���20%/�������80%</td>
                </tr>
            </table>
        </td>
    </tr>	  
    <tr>
        <td>&nbsp;*  �ݿ� : ä��ķ���� �ǹݿ����Դϴ�. <%if(gubun3.equals("5")){%>(��ü���ڸ� ������ ����Ʈ�Դϴ�. ��ü�� [������ȸ-�̼�����ü]�� �˻��Ͻʽÿ�.)<%}%>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
