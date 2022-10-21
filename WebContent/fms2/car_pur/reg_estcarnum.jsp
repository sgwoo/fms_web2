<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.user_mng.*, acar.car_sche.*,acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//��ǰ���� ������
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//�������
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	
	String gubun = c_db.getNameByIdCode("0032", "", car.getCar_ext());
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function update(){		
		var fm = document.form1;
		if(fm.est_car_num.value.length != 17){
			alert("�����ȣ�� 17�ڸ��� �Է����ּ���.");
		}else{
			fm.action='reg_estcarnum_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
</head>

<body>
<!-- <center> -->
<form name='form1' action='' method='post' style="margin-left:15px;">
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="mode" value="<%=mode%>">
<table border="0" cellspacing="0" cellpadding="0" width=570>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�����ȣ ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	      <%	Hashtable est = a_db.getRentEst(m_id, l_cd);%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����ȣ</td>
                    <td width='29%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>��ȣ</td>
                    <td width='41%'>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>�������</td>
                    <td>&nbsp;<%=gubun%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>
                <tr> 
                    <td class='title'>�����ȣ</td>
                    <td colspan='3'>&nbsp;<%=pur.getRpt_no()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>���������ȣ</td>
                    <td>&nbsp;<%=pur.getEst_car_no()%></td>
                </tr>
                <tr> 
                    <td class='title'>�����ȣ</td>
                    <td>&nbsp;<input type="text" size="30" name="est_car_num" id="est_car_num" class="text" value="<%=pur.getCar_num()%>" placeholder="�ݵ�� 17�ڸ��� �Է����ּ���.">
    			    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
		<%	String reg_id1 = nm_db.getWorkAuthUser("���������");
			String reg_id2 = nm_db.getWorkAuthUser("�λ����������");
			String reg_id3 = "";
			String reg_id4 = "";
			String reg_id5 = nm_db.getWorkAuthUser("����������");
			String reg_id6 = "";
			String reg_id7 = nm_db.getWorkAuthUser("�λ꺸����");
			String reg_id8 = "";
			String reg_id0 = nm_db.getWorkAuthUser("���纸����");
			CarScheBean cs_bean = csd.getCarScheTodayBean(reg_id1);
			if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
				reg_id3 = cs_bean.getWork_id();
			}
			cs_bean = csd.getCarScheTodayBean(reg_id2);
			if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
				reg_id4 = cs_bean.getWork_id();
			}
			cs_bean = csd.getCarScheTodayBean(reg_id5);
			if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
				reg_id6 = cs_bean.getWork_id();
				cs_bean = csd.getCarScheTodayBean(reg_id6);//������������ �ް��ε� ������ü�ڵ� �ް��� ��� ��3 ������ü�ڷ� ��ü
				if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
					reg_id6 = cs_bean.getWork_id();
				}
			}
			cs_bean = csd.getCarScheTodayBean(reg_id7);
			if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
				reg_id8 = cs_bean.getWork_id();
				cs_bean = csd.getCarScheTodayBean(reg_id8);//�λ꺸������ �ް��ε� ������ü�ڵ� �ް��� ��� ��3 ������ü�ڷ� ��ü
				if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
					reg_id8 = cs_bean.getWork_id();
				}
			}
			%>
		<%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("������ڵ��",ck_acar_id) || nm_db.getWorkAuthUser("��������",ck_acar_id) || nm_db.getWorkAuthUser("�������������",ck_acar_id) || nm_db.getWorkAuthUser("���������",ck_acar_id) || nm_db.getWorkAuthUser("��ǰ�غ��Ȳ��Ͼ���",ck_acar_id) || ck_acar_id.equals(reg_id1) || ck_acar_id.equals(reg_id2) || ck_acar_id.equals(reg_id3) || ck_acar_id.equals(reg_id4) || ck_acar_id.equals(reg_id5) || ck_acar_id.equals(reg_id6) || ck_acar_id.equals(reg_id7) || ck_acar_id.equals(reg_id8) || ck_acar_id.equals(reg_id0)){%>		
		<a href="javascript:update()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
		<%}%>
		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
	//�����ȣ ���ҹ��� �빮�ڷ� ����		2018.01.30
	var est_car_num = $("#est_car_num");
	est_car_num.change(function(){
		var regex = /[^0-9A-Za-z]/gi;
		var oldLetter = est_car_num.val();
		var modifiedString = oldLetter.replace(regex, "");	// ����, ���� �̿� ����
		modifiedString = modifiedString.toUpperCase();		// ���ҹ��� �빮�ڷ� ����		
		est_car_num.val(modifiedString);
	});
</script>
<!-- </center> -->
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
