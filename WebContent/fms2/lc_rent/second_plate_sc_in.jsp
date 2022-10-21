<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//chrome ���� 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count = 0;
	
	Vector vt = a_db.getCarSecondPlateList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3);
	int vt_size = vt.size();
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

<script language='javascript'>
<!--
//-->
</script>
</head>
<body>

<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 770px;">
					<div style="width: 780px;">
						<table class="inner_top_table left_fix" style="height: 40px;">
							<colgroup>
				       			<col width="50">
				       			<col width="50">
				       			<col width="120">
				       			<col width="150">
				       			<col width="100">
				       			<col width="150">
				       			<col width="150">
				       		</colgroup>
							<tr>
								<td width="50" class="title title_border">����</td>
								<td width="50" class="title title_border">����</td>
								<td width='120' class="title title_border">����ȣ</td>
								<td width='150' class="title title_border">�����ȣ</td>
			                    <td width="100" class="title title_border">������ȣ</td>
			                    <td width="150" class="title title_border">����</td>
			                    <td width="150" class="title title_border">��ȣ</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 40px;">
							<colgroup>
				       			<col width="80">
				       			<col width="80">
				       			<col width="100">
				       			<col width="120">
				       			<col width="120">
				       			<col width="120">
				       			<col width="150">
				       			<col width="100">
				       			<col width="250">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="330">
				       		</colgroup>
							<tr>
								<td width="80" class="title title_border">����</td>
	                           	<td width="80" class="title title_border">������</td>
	                           	<td width="100" class="title title_border">����ڵ����</td>
	                           	<td width="120" class="title title_border">���������</td>
	                           	<td width="120" class="title title_border">���ε��ε</td>
	                           	<td width="120" class="title title_border">�����Ӱ�����</td>
	                           	<td width="150" class="title title_border">���� ������</td>
	                           	<td width="100" class="title title_border">������ ����ó</td>
	                           	<td width="250" class="title title_border">����������</td>
	                           	<td width="100" class="title title_border">�����</td>
	                           	<td width="100" class="title title_border">��û��</td>
	                           	<td width="100" class="title title_border">ȸ������</td>
	           					<td width="330" class="title title_border">��Ÿ����</td>
		        	   		</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb">
			<tr>
				<td style="width: 770px;">
					<div style="width: 780px;">
						<table class="inner_top_table left_fix">
					<%if (vt.size() > 0 ) {%>
						<%for (int i = 0; i < vt.size(); i++) {
							Hashtable ht = (Hashtable)vt.elementAt(i);
						%>
							<tr style="height: 25px;"> 							
	                            <td width="50" class="center content_border"><%=i+1%></td>
	                            <td width="50" class="center content_border">
	                            <%if (String.valueOf(ht.get("USE_YN")).equals("Y")) {%>
	                            	����
	                            <%} else if (String.valueOf(ht.get("USE_YN")).equals("N")) {%>
	                            	����
	                            <%}%>
	                            </td>
	                            <td width="120" class="center content_border">
	                            	<a href="javascript:parent.update_info('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
	                            		<%=ht.get("RENT_L_CD")%>
	                            	</a>
	                            </td>
	                            <td width="150" class="center content_border"><%=ht.get("CAR_NUM")%></td>
	                            <td width="100" class="center content_border"><%=ht.get("CAR_NO")%></td>
	                            <td width="150" class="center content_border">
	                            	<span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span>
	                            </td>
	                            <td width="150" class="center content_border">
	                            	<span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span>
	                            </td>
                            </tr>
						<%}%>
					<%} else {%>
							<tr>
								<td width="800" class="center content_border" colspan="7">��ȸ�� ������ �����ϴ�.</td>
							</tr>
					<%}%>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout">
					<%if (vt.size() > 0 ) {%>
						<%for (int i = 0; i < vt.size(); i++) {
							Hashtable ht = (Hashtable)vt.elementAt(i);
						%>
							<tr style="height: 25px;"> 							
								<td width="80" class="center content_border">
									<%if (ht.get("SECOND_PLATE_YN").equals("Y")) {%>��û<%} else if (ht.get("SECOND_PLATE_YN").equals("R")) {%>ȸ��<%} else if (ht.get("SECOND_PLATE_YN").equals("N")) {%>��ȸ��<%}%>
								</td>
	                           	<td width="80" class="center content_border">
	                           		<%if (ht.get("WARRANT").equals("Y")) {%>�ʼ�<%}%>
	                           	</td>
	                           	<td width="100" class="center content_border">
	                           		<%if (ht.get("BUS_REGIST").equals("Y")) {%>�ʿ�<%} else {%>���ʿ�<%}%>
	                           	</td>
	                           	<td width="120" class="center content_border">
	                           		<%if (ht.get("CAR_REGIST").equals("1")) {%>�纻<%} else if (ht.get("CAR_REGIST").equals("2")) {%>����(ȸ���ʼ�)<%}%>
	                           	</td>
	                           	<td width="120" class="center content_border">
	                           		<%if (ht.get("CORP_REGIST").equals("Y")) {%>�ʿ�<%} else {%>���ʿ�<%}%>
	                           	</td>
	                           	<td width="120" class="center content_border">
	                           		<%if (ht.get("CORP_CERT").equals("Y")) {%>�ʿ�<%} else {%>���ʿ�<%}%>
	                           	</td>
	                           	<td width="150" class="center content_border"><%=ht.get("RE_CLIENT_NM")%></td>
	                           	<td width="100" class="center content_border"><%=ht.get("RE_CLIENT_NUMBER")%></td>
	                           	<td width="250" class="center content_border">
	                           		<%
	                           		String zip = String.valueOf(ht.get("CLIENT_ZIP"));
	                           		String addr = String.valueOf(ht.get("CLIENT_ADDR"));
	                           		String detail_addr = String.valueOf(ht.get("CLIENT_DETAIL_ADDR"));
	                           		String full_addr = zip + " " + addr + " " + detail_addr;
	                           		%>
	                           		<span title="<%=full_addr%>"><%=AddUtil.subData(full_addr, 20)%></span>
	                           	</td>
	                           	<td width="100" class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
	                           	<td width="100" class="center content_border"><%=ht.get("REG_NM")%></td>
	                           	<td width="100" class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RETURN_DT")))%></td>
	           					<td width="330" class="center content_border"><%=ht.get("ETC")%></td>
           					</tr>
						<%}%>
					<%} else {%>
							<tr>
								<td  class="center content_border" colspan="13">&nbsp;</td>
							</tr>
					<%}%>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>	
</div>

</form>
</body>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</html>
