<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.partner.*"%>
<jsp:useBean id="pt_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	
	
	
	int fin_seq = request.getParameter("fin_seq")==null?0:Integer.parseInt(request.getParameter("fin_seq"));
			
	int count = 0;

	FinManBean base = pt_db.getFinManBase(fin_seq);
	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

function PartherUpdate()
{
	var theForm = document.form1;
	theForm.cmd.value = "u";
		
	if(confirm('�����Ͻðڽ��ϱ�?')){	
			theForm.action='partner_fin_a.jsp';		
			theForm.target='i_no';
			theForm.submit();
		}
}

function search_zip(str)
{
		window.open("./zip_s.jsp?idx="+str, "�����ȣ�˻�", "left=100, height=200, width=350, height=300, scrollbars=yes");
}

function PartherDel()
{
	var theForm = document.form1;
	theForm.cmd.value = "d";
		
	if(confirm('�����Ͻðڽ��ϱ�?')){	
			theForm.action='partner_fin_a.jsp';		
			theForm.target='i_no';
			theForm.submit();
	}
}	
//-->
</script>
<style type=text/css>

<!--

.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body leftmargin="15" onLoad="self.focus()">

<form action="" name="form1" method="POST" >
<input type='hidden' name="fin_seq" value="<%=fin_seq%>"> 
<input type='hidden' name='cmd' value=''>

<table border=0 cellspacing=0 cellpadding=0 width="700">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> ���¾�ü >����ڰ��� > <span class=style5>����� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>
	    	<table border="0" cellspacing="1" cellpadding="0" width="100%">
	    		<tr>
			    	<td width=10% class=title>����</td>
			    	<td width=15% align="center">
			    	   <select name="gubun" >
			                      <option value='�繫��ǥ' <%if(base.getGubun().equals("�繫��ǥ")) out.println("selected");%>>�繫��ǥ</option>
					    <option value='�����' <%if(base.getGubun().equals("�����")) out.println("selected");%>>�����</option>					
			  	  </SELECT></td>
			    	<td width=10% class=title>��ȣ</td>
			    	<td width=23% align="center"><input type="text" name="com_nm" value="<%=base.getCom_nm()%>" size="25" class=text ></td>
			    	<td width=10% class=title>������</td>
			    	<td width=23% align="center" ><input type="text" name="br_nm" value="<%=base.getBr_nm()%>" size="25" class=text  ></td>
			    </tr>
			    <tr>
			    	<td width=10% class=title>�����</td>
			    	<td width=15% align="center"><input type="text" name="agnt_nm" value="<%=base.getAgnt_nm()%>" size="15" class=text></td>
			    	<td width=10% class=title>����</td>
			    	<td width=23% align="center"><input type="text" name="agnt_title" value="<%=base.getAgnt_title()%>" size="25" class=text></td>
			    	<td width=10% class=title>E-mail</td>
			    	<td width=23% align="center"><input type="text" name="fin_email" value="<%=base.getFin_email()%>" size="25" class=text style='IME-MODE: inactive'></td>
			    </tr>
			    <tr>
			    	<td width=10% class=title>�����HP</td>
			    	<td width=15% align="center"><input type="text" name="fin_m_tel" value="<%=base.getFin_m_tel()%>" size="15" class=text></td>
			    	<td width=10% class=title>�������ȭ</td>
			    	<td width=23% align="center"><input type="text" name="fin_tel" value="<%=base.getFin_tel()%>" size="25" class=text></td>
			    	<td width=10% class=title>������ѽ�</td>
			    	<td width=23% align="center"><input type="text" name="fin_fax" value="<%=base.getFin_fax()%>" size="25" class=text></td>
			    </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								// �˾����� �˻���� �׸��� Ŭ�������� ������ �ڵ带 �ۼ��ϴ� �κ�.

								// ���θ� �ּ��� ���� ��Ģ�� ���� �ּҸ� �����Ѵ�.
								// �������� ������ ���� ���� ��쿣 ����('')���� �����Ƿ�, �̸� �����Ͽ� �б� �Ѵ�.
								var fullRoadAddr = data.roadAddress; // ���θ� �ּ� ����
								var extraRoadAddr = ''; // ���θ� ������ �ּ� ����

								// ���������� ���� ��� �߰��Ѵ�. (�������� ����)
								// �������� ��� ������ ���ڰ� "��/��/��"�� ������.
								if(data.bname !== '' && /[��|��|��]$/g.test(data.bname)){
									extraRoadAddr += data.bname;
								}
								// �ǹ����� �ְ�, ���������� ��� �߰��Ѵ�.
								if(data.buildingName !== '' && data.apartment === 'Y'){
								   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
								}
								// ���θ�, ���� ������ �ּҰ� ���� ���, ��ȣ���� �߰��� ���� ���ڿ��� �����.
								if(extraRoadAddr !== ''){
									extraRoadAddr = ' (' + extraRoadAddr + ')';
								}
								// ���θ�, ���� �ּ��� ������ ���� �ش� ������ �ּҸ� �߰��Ѵ�.
								if(fullRoadAddr !== ''){
									fullRoadAddr += extraRoadAddr;
								}
								
								document.getElementById('fin_zip').value = data.zonecode;
								document.getElementById('fin_addr').value = fullRoadAddr;
								
								// ����ڰ� '���� ����'�� Ŭ���� ���, ���� �ּҶ�� ǥ�ø� ���ش�.
								if(data.autoRoadAddress) {
									//����Ǵ� ���θ� �ּҿ� ������ �ּҸ� �߰��Ѵ�.
									var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
									document.getElementById('fin_addr').innerHTML = '(���� ���θ� �ּ� : ' + expRoadAddr + ')';

								} else if(data.autoJibunAddress) {
									var expJibunAddr = data.autoJibunAddress;
									document.getElementById('fin_addr').innerHTML = '(���� ���� �ּ� : ' + expJibunAddr + ')';

								} else {
									document.getElementById('fin_addr').innerHTML = '';
								}
							}
						}).open();
					}
				</script>	
   			    <tr>
			    	<td width=10% class=title>������ּ�</td>
			    	<td colspan="5" >&nbsp;
					<input type="text" name="fin_zip"  id="fin_zip" size="7" maxlength='7' value="<%=base.getFin_zip()%>">
						<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="fin_addr" id="fin_addr" size="65" value="<%=base.getFin_addr()%>">
					</td>
		    	   </tr>
		    	   <tr>
			    	<td width=10% class=title>��뿩��</td>
			    	 <td  >&nbsp; <select name="use_yn" >
			                      <option value='Y' <%if(base.getUse_yn().equals("Y")) out.println("selected");%>>Y</option>
					    <option value='N' <%if(base.getUse_yn().equals("N")) out.println("selected");%>>N</option>					
			  	  </SELECT></td>
			  	  <td width=10% class=title>����</td>
			    	<td  colspan=3 align="center"><input type="text" name="sort" value="<%=base.getSort()%>" size="5" class=num></td>			    	
		    	  </tr>
			
			</table>
    	</td>
    </tr>
    
	<tr>
    	<td align="right" height=25>
    		<a href="javascript:PartherUpdate()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
    		<a href="javascript:PartherDel()"><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>&nbsp;
    		<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>

</form>

</body>
</html>