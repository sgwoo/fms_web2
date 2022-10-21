<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":AddUtil.replace(request.getParameter("st_dt"),"-","");
	String end_dt 	= request.getParameter("end_dt")==null?	"":AddUtil.replace(request.getParameter("end_dt"),"-","");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//chrome ����
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(rent_mng_id, rent_l_cd);
	
	//�ŷ�ó����
	ClientBean client = al_db.getClient(String.valueOf(base.get("CLIENT_ID")));
	
	Vector vt = a_db.getContList_20160614("99", String.valueOf(base.get("FIRM_NM")), andor, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt);		
	int cont_size = vt.size();
	 
  	String dot_auth = "";
  	String tax_auth = "";
  	String car_auth = "";
  	
  	if (nm_db.getWorkAuthUser("�����ڸ��",user_id)||nm_db.getWorkAuthUser("������������", user_id)) {
  		dot_auth = "Y";
  	}
  	
  	if (nm_db.getWorkAuthUser("�����Һ񼼴��",user_id)) {
  		tax_auth = "Y";
  	}
  	
  	if (nm_db.getWorkAuthUser("������������",user_id)||nm_db.getWorkAuthUser("�����ⳳ", user_id)) {
  		car_auth = "Y";
  	}
  	
  	if (nm_db.getWorkAuthUser("������",user_id)) {
  		dot_auth = "Y";
  		tax_auth = "Y";
  		car_auth = "Y";
  	}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><!-- ȣȯ�� ���� �߰��� ȭ���� ������ ���� ���� 2018.04.04 -->
<title>FMS - �����Ȳ</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.button_style:hover {
    background-color: #525D60;
}
.button_style {
	background-color: #6d758c;
    font-size: 12px;
    cursor: pointer;
    border-radius: 2px;
    color: #fff;
    border: 0;
    outline: 0;
    padding: 5px 8px;
    margin: 3px;
}
.button_style2 {
	background-image: linear-gradient(#919191, #787878);
    font-size: 10px;
    font-weight: bold;
    cursor: pointer;
    border-radius: 3px;
    color: #FFF;
    border: 0;
    outline: 0;
    padding: 5px 8px;
    margin: 3px;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">
<!--

	//��ü���� �� ����
	function AllSelect() { 
		var fm = document.form1;
		var check_val_length = document.getElementsByName("check_value").length;
		if (fm.ch_all.checked == true) {
			for (var i = 0; i < check_val_length; i++) {
				if (check_val_length == 1) {
					fm.check_value.checked = true;
				} else {
					fm.check_value[i].checked = true;
				}
			}
		} else {
			for (var z = 0; z < fm.check_value.length; z++) {
				if (check_val_length == 1) {
					fm.check_value.checked = false;
				} else {
					fm.check_value[z].checked = false;
				}
			}
		}
	}
	
	//�뿩�� ������ ���� �μ�ȭ��
	function print_view(rent_mng_id, rent_l_cd) {
		var fm = document.form1;
		var stamp_yn = "";

		if (fm.stamp_yn.checked == true) {
			stamp_yn = "Y";
		} else {
			stamp_yn = "N";
		}
		
		var SUBWIN="./scd_fee_print2.jsp?rent_mng_id=" + rent_mng_id + "&rent_l_cd=" + rent_l_cd + "&stamp_yn=" + stamp_yn;
		
		alert("�μ�̸������ ������ Ȯ���� ����Ͻñ⸦ �����մϴ�.");
		
		window.open(SUBWIN, "_blank", "left=100, top=100, width=950, height=800, scrollbars=yes");
	}
	
	//��������ϱ�
	function print_view_all() {
		var fm = document.form1;
		var cnt = 0;
		var idnum = "";
		for (var i = 0; i < fm.elements.length; i++) {
			var ck = fm.elements[i];
			if (ck.name == "check_value") {
				if (ck.checked == true) {
					cnt++;
					idnum = ck.value;
				}
			}
		}
		
		if (cnt == 0) {
		 	alert("�μ��� ����� �������ּ���.");
			return;
		} else {
			alert("�μ�̸������ ������ Ȯ���� ����Ͻñ⸦ �����մϴ�.");
		}
		
		var url = "./scd_fee_check_print2.jsp";
		var title = "openPop";
		var status = "left=100, top=100, width=950, height=800, scrollbars=yes";
		window.open("", title, status); //window.open(url, title, status); window.open �Լ��� url�� �տ��� ����
        
		fm.target = title;
        fm.action = url;
        fm.method = "post";
        fm.submit();	
	}
	
	//�������Ϲ߼�
	function send_mail(rent_mng_id, rent_l_cd) {
		var fm = document.form1;
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value = rent_l_cd;

        if (confirm("������ �߼� �Ͻðڽ��ϱ�?")) {
			fm.send_type.value = "single";

			fm.target = "i_no";
			fm.action = "/acar/car_rent/scd_fee_rent_list_a.jsp";
	        fm.method = "post";
	        fm.submit();
		}
	}

	//���ø��Ϲ߼�
	function send_mail_all() {
		var fm = document.form1;
		var cnt = 0;
		var idnum = "";
		for (var i = 0; i < fm.elements.length; i++) {
			var ck = fm.elements[i];
			if (ck.name == "check_value") {
				if (ck.checked == true) {
					cnt++;
					idnum = ck.value;
				}
			}
		}

		if (cnt == 0) {
		 	alert("������ �߼��� ����� �������ּ���.");
			return;
		} else {
			if (confirm("������ �߼� �Ͻðڽ��ϱ�?")) {
				fm.send_type.value = "multi";
				
				fm.target = "i_no";
				fm.action = "/acar/car_rent/scd_fee_rent_list_a.jsp";
		        fm.method = "post";
		        fm.submit();
			}
		}
	}
	
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name="cmd" value="ing">
<input type='hidden' name="send_type" value="">
<input type='hidden' name="idx" value="">
<input type='hidden' name="rent_mng_id" value="">
<input type='hidden' name="rent_l_cd" value="">
<input type='hidden' name="car_mng_id" value="">
<input type="hidden" name="firm_nm" value="<%=base.get("FIRM_NM")%>">
<!-- �߰��κ� -->
<table width=950 border=0 cellspacing=0 cellpadding=0 style="padding: 0px 0px 0px 10px;">                            
    <tr>
        <td height=10></td>
    </tr>
    <tr>
        <td width=1250 valign=top>
            <table width=1250 border=0 cellspacing=0 cellpadding=0>
                <!-- ����� -->
                <tr>
                    <td>
                        <table width=1250 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td>
	                            	<span style="font-size: 16px; font-weight: bold;"><%=base.get("FIRM_NM")%> ������ ��� ��Ȳ �Դϴ�.</span>
                                </td>
            				</tr>
        				</table>
    				</td>
				</tr>
				<!-- ����� -->
				<tr>
				    <td height=20></td>
				</tr>
				<!-- ��뼳�� -->
				<tr>
				    <td align=center>
				        <table width=1250 border=0 cellspacing=0 cellpadding=0>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red;"><%=AddUtil.getDate()%></span> ���縦 �������� ��ȸ�� �����Ȳ�Դϴ�.</td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;�뿩�� ������ ȭ�鿡�� <span style="color: red;">�μ� �̸������ ������ ����ũ�⿡ ���� ���� ���</span> �Ʒ��� ���� ���� ���ּ���.</td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red;">ũ��(Chrome)</span> : ���콺 ��Ŭ�� > �μ� > ���� ������ > ���� �� ���� ���� ���� ����.</td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red;">�ͽ��÷η�(explorer)</span> : ���콺 ��Ŭ�� > �μ� �̸� ���� > ����(��Ϲ������) > ũ�⿡ �°� ��� ��� �� üũ.</td>
							</tr>
							<tr>
							    <td height=10></td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red; font-weight: bold;">�뿩�ὺ���� �ۼ��� ���� ���� ������ �μ� �� ���Ϲ߼��� �Ұ� �մϴ�.</span></td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red; font-weight: bold;">�̸� �� �̸��� ������ �Ѱ��� ��������� ���� ��ȸ�� �ŷ�ó ����� �����Դϴ�.</span></td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red; font-weight: bold;">���뿩�����پȳ����� ��û�Ͽ� �ް����ϴ� �ŷ�ó ����ڿ� �ٸ� �� �ֽ��ϴ�. �̸��� �߼��� �ް����ϴ� �ŷ�ó ����ڸ� �ݵ�� Ȯ�� ���ּ���.</span></td>
							</tr>
							<tr>
							    <td height=10></td>
							</tr>
				        </table>
				    </td>
				</tr>
				<!-- ��뼳�� -->
				<tr>
				    <td height=10></td>
				</tr>
				<tr>
					<td align="right">
						<input type="checkbox" name="stamp_yn" id="stamp_yn" value="Y" checked><label for="stamp_yn">����ǥ��</label>
						&nbsp;&nbsp;&nbsp;
						<span style="font-weight: bold;">�̸�&nbsp;:&nbsp;</span>
						<input type="text" size="15" name="con_agnt_nm" value="<%=client.getCon_agnt_nm()%>" maxlength="20" class="text">
						&nbsp;&nbsp;&nbsp;
						<span style="font-weight: bold;">�̸���&nbsp;:&nbsp;</span>
						<input type="text" size="40" name="con_agnt_email" value="<%=client.getCon_agnt_email()%>" maxlength="30" class="text">
						&nbsp;&nbsp;&nbsp;
						<input class="button_style" type="button" value="�뿩�� ������ ���� �μ�" onclick="print_view_all();">
						<input class="button_style" type="button" value="�뿩�� ������ ���� ���Ϲ߼�" onclick="send_mail_all();">
					</td>
				</tr>
				<tr>
				    <td height=10></td>
				</tr>
				<tr>
				    <td>
				        <table width=1250 border=0 cellpadding=0 cellspacing=1 bgcolor=a6b1d6>
				            <tr>
				            	<td width=30 class=title height=25>����</td>
				            	<td width=30 class=title>
				            		<input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();">
				            	</td>				            	
				                <td width=40 class=title>����</td>
				                <td width=80 class=title>����ȣ</td>
				                <td width=70 class=title>�����</td>
				                <td width=70 class=title>������ȣ</td>
				                <td width=100 class=title>����</td>
				                <td width=70 class=title>���������</td>
				                <!-- <td width=130 class=title>�����̿���</td> -->
				                <td width='80' class='title'>��������</td>
								<td width='70' class='title'>��౸��</td>
								<td width='70' class='title'>��������</td>
								<td width='70' class='title'>�뵵����</td>
								<td width='70' class='title'>��������</td>
				                <td width=60 class=title>�뿩�Ⱓ</td>
				                <td width=70 class=title>�뿩������</td>
				                <td width=70 class=title>��ุ����</td>
				                <td width=110 class=title>�뿩�ὺ����</td>
				            </tr>
							<%
							for (int i = 0; i < cont_size; i++) {
								Hashtable ht = (Hashtable)vt.elementAt(i);
								
								//�뿩���� ī����
								int fee_count	= af_db.getFeeCount(String.valueOf(ht.get("RENT_L_CD")));
								String rent_st = String.valueOf(fee_count);
								
								//�����뿩������ �뿩Ƚ�� �ִ밪
								int max_fee_tm 	= a_db.getMax_fee_tm(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), rent_st);
								//System.out.println(max_fee_tm);
							%>
							<tr>
							    <td class=content height=25 align=center><%=i+1%></td>
							    <td class=content height=25 align=center>
							    	<%-- <%if (!ht.get("RENT_START_DT").equals("")) {%> --%>
							    	<%if (max_fee_tm > 0) {%>
							    	<input type="checkbox" name="check_value" value="<%=ht.get("RENT_MNG_ID")%>_<%=ht.get("RENT_L_CD")%>_<%=ht.get("RENT_ST")%>">
							    	<%}%>
							    </td>
							    <td class=content height=25 align=center>
							    	<%if (String.valueOf(ht.get("USE_YN")).equals("")) {%>
                           				<%=ht.get("SANCTION_ST")%>
                       				<%} else if (String.valueOf(ht.get("USE_YN")).equals("Y")) {%>
                       					����
                       				<%} else if (String.valueOf(ht.get("USE_YN")).equals("N")) {%>
                       					����
                       				<%}%>
							    </td>
								<td class=content align=center><%=ht.get("RENT_L_CD")%></td>
								<td class=content align=center><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
								<td class=content align=center>
									<span class=style8><%=ht.get("CAR_NO")%></span>
								</td>
								<td class=content align=center><font color=4d4d4d><%=ht.get("CAR_NM")%></font></td>
								<td class=content align=center><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
								<%-- <td class=content align=center><span class=style8><%=ht.get("MGR_NM")%></span></td> --%>
																
								<td width='80' align='center'><%=ht.get("CLS_ST")%></td>
								<td width='70' align='center'>
								<%if (String.valueOf(ht.get("CNG_ST")).equals("")) {%>
									<%if (String.valueOf(ht.get("EXT_ST")).equals("")) {%>
											<%=ht.get("RENT_ST")%>
									<%} else {%>
											<%=ht.get("EXT_ST")%>
									<%}%>
								<%} else {%>
									<%if (String.valueOf(ht.get("EXT_ST2")).equals("")) {%>
											<%=ht.get("CNG_ST")%>
									<%} else {%>
											<%=ht.get("EXT_ST2")%>
									<%}%>
								<%}%>
								</td>
								<td width='70' align='center'><%=ht.get("CAR_GU")%></td>
								<td width='70' align='center'><%=ht.get("CAR_ST")%></td>
								<td width='70' align='center'><%=ht.get("RENT_WAY")%></td>	
								
								<td class=content align=center><%if(!String.valueOf(ht.get("CON_MON")).equals("")){%><%=ht.get("CON_MON")%>����<%}else{%>-<%}%></td>
								
								<td class=content align=center><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
								<td class=content align=center><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
								<td class=content align=center>
									<%-- <%if (!ht.get("RENT_START_DT").equals("")) {%> --%>
							    	<%if (max_fee_tm > 0) {%>
									<input type="button" class="button_style" value="�μ�" onclick="print_view('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>');"> 
									<input type="button" class="button_style" value="����" onclick="send_mail('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>');"> 
									<%}%>
								</td>
							</tr>
							<%}%>
							<%if (cont_size == 0) {%>
							<tr>
								<td height=25 colspan="11" align=center class=content>�ش� ����Ÿ�� �����ϴ�. </td>
							</tr>
							<%}%>
       					</table>
    				</td>
				</tr>
				<%-- 
				<%if (vt_size > 0) {%>
				<tr>
					<td height=25 align="right"><a href="javascript:ListPrint()"><img src="../../sub/images/button_print.gif" align=absMiddle border=0></a></td>
				</tr>
				<%}%> 
				--%>
			</table>
		</td>
    </tr>
</table>
<!-- �߰��κ� -->
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" noresize></iframe>
</body>
</html>
