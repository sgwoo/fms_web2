<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.alink.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>

<%
	String doc_code = request.getParameter("doc_code")==null?"":request.getParameter("doc_code");
		
	//���ڹ��� ���� doc_code 
	Hashtable ht = ln_db.getALink("e_doc_mng", doc_code);
	String sign_type = ht.get("SIGN_TYPE")+"";
	String doc_type = ht.get("DOC_TYPE")+"";
%>

<html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title>�Ƹ���ī ���ڹ���</title>
<style type="text/css">
<!--
.style1 {
	color: #747474;
	font-weight: bold;
	font-family:nanumgothic;
}
.style2 {color: #747474}
.style3 {
	color: #ff00ff;
	font-weight: bold;
}
.style4 {color: #626262}
.style5 {color: #376100}
.style6 {
	color: #FFFFFF;
	font-weight: bold;
}
.style8 {color: #696969}
.style9 {
	color: #f75802;
}
-->
</style>


</head>
<body topmargin=0 leftmargin=0>

<div style="width: 700px; margin: 0 auto;">
	<div style="padding: 5px 10px; text-align: left;">
		<a href="https://www.amazoncar.co.kr" target="_blank">
			<img src="https://www.amazoncar.co.kr/resources/images/logo_1.png" style="width: 150px;"/>
		</a>
	</div>
	<div style="text-align: center; width: 700px; background-color: #9bb345; border: 1px solid #d2e38d; border-radius: 10px;">
		<div style="text-align: center; width: 700px; background-color: #FFFFFF; border-radius: 10px; margin: 8px 0px;">
			<!-- title_start -->
			<div style="padding: 20px 20px;">
				<span style="font-size:20px;">�Ƹ���ī ���ڹ��� �߼� �ȳ���</span>
			</div>
			<div style="margin: 30px 20px; font-family: nanumgothic; font-size:13px; border: 3px solid #e0e0e0;">
				<div style="padding: 10px 0px 10px 50px; text-align: left; line-height: 22px;">
					<span style="font-weight: bold;"><%=ht.get("FIRM_NM")%></span>&nbsp;��<br>
					<%if(sign_type.equals("1") || sign_type.equals("2")){ %>
					<span style="color: #FF00FF; font-weight: bold;"><%=ht.get("DOC_NAME") %></span> �����û�� �Խ��ϴ�. ������ Ȯ���ϰ� �������ּ���.<br>
					<%}else{ %>
					<span style="color: #FF00FF; font-weight: bold;"><%=ht.get("DOC_NAME") %></span> ������ �߼۵Ǿ����ϴ�. ������ Ȯ���ϰ� �������ּ���.<br>
					<%} %>	
					(���� �� Ȯ�� ���ɱⰣ : �߼��Ϸκ��� 30��, ���� ���� ���)<br>
					<%if(doc_type.equals("1")){ %>										
					<%	if(sign_type.equals("1")){ %>
					* ���뿩��༭ ������ ������ ��� �ڵ���ü��û���� ������ ���Ϲ߼۵˴ϴ�. ��û�� �ۼ��� ȸ���Ͽ� �ֽʽÿ�.<br>
					<%	} %>
					* ����� ����ó�� ��༭�� �����Ͻʽÿ�.
					<%} %>			
				</div>
			</div>
			<!-- title_end -->	
			<!-- content_start -->			
			<div style="padding: 10px 20px;">				
				<a href="https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code=<%=doc_code%>" target='_blank' style="padding: 5px 15px; background: #efefef; text-decoration: none; border-radius: 5px; color: #000000; border: 1px solid #000; font-size: 15px;">
					���� Ȯ���ϱ�
				</a>
			</div>
			
			<div style="padding: 25px 0px 10px 0px;">
				<div style="margin: 0px 15px; padding: 2px; font-family: nanumgothic; font-size: 11px; ">
					��ȿ�Ⱓ (<%=ht.get("REG_DT") %>~<%=ht.get("TERM_DT") %>)
				</div>
			</div>
			
			<div style="margin: 0px 20px 5px 20px; font-family: nanumgothic; font-size: 14px; line-height: 22px; text-align: left; font-weight: bold; border-bottom: 1px solid #9cb445;">
				* ������
			</div>
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 12px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px 10px 10px 30px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px; text-align: left;">				
					1. ��й�ȣ�� ����/���λ����-����ڵ�Ϲ�ȣ, ����-������ϸ� �Է��ϼž� �մϴ�.<br>
					2. �Է��Ͻ� ��й�ȣ�� ��ġ���� ���� ��쿡�� <span style="color: #f75802;">IT�� 02-392-4243</span> �Ǵ� <span style="color: #f75802;">����(<a href=mailto:dev@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">dev@amazoncar.co.kr</span></a>)</span>��<br>
					&nbsp;&nbsp;&nbsp;�����ֽñ� �ٶ��ϴ�.
				</div>
			</div>
			
			<div style="margin: 0px 20px 5px 20px; font-family: nanumgothic; font-size: 14px; line-height: 22px; text-align: left; font-weight: bold; border-bottom: 1px solid #9cb445;">
				* ���Ž� ���ǻ���
			</div>
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 12px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px 10px 10px 30px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px; text-align: left;">
					1. ���Բ��� ������ ������ �ƴϽø� <span style="color: #f75802;">����(<a href=mailto:dev@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">dev@amazoncar.co.kr</span></a>)</span>�� �����ֽñ� �ٶ��ϴ�.<br>
					2. �� ���ϰ� ��ũ�� �������� ���ʽÿ�. �������� ���� ��3�ڰ� ������ Ȯ���� �� �ֽ��ϴ�.<br>
					3. ���ϰ����� �����Ͽ� �ֽʽÿ�. ���� ����� ���õ� ������ ���Ϸ� ���۵˴ϴ�. ���� ����, ���� �ź� �� ������� ��å������ ������ ���۵��� �ʴ� ������ �߻��� �� �ֽ��ϴ�.<br>
					4. �Է��� ������ ����ȿ���� �����˴ϴ�. ����� �� ���ǰ� �־�߸� �Է��� �� �ִ� �Ƹ���ī ������ ���ڼ���� ��3��3�׿� ���� ���� ȿ���� �����˴ϴ�. ���� ����� �ð�, ������ �ּ� �� ���� ����� ���õ� ��� �κ��� ��ϵǸ�, ������ �Ϸ�� ������ �̸��Ϸ� ���۵˴ϴ�. �̸� ���� ����/����/���� ���θ� Ȯ���� �� �ֽ��ϴ�.  
				</div>
			</div>	
			
			<div style="padding: 25px 0px 10px 0px;">
				<div style="margin: 0px 15px; padding: 20px; font-family: nanumgothic; font-size: 11px; border-top: 1px dotted; border-bottom: 1px dotted;">
					�� ������ �߽����� �����̹Ƿ� �ñ��� ������ <a href="mailto:dev@amazoncar.co.kr"><span style="font-size: 11px; color: #af2f98; font-family: nanumgothic;">���Ÿ���(dev@amazoncar.co.kr)</span></a>�� �����ֽñ� �ٶ��ϴ�.</span>
				</div>
			</div>
			<!-- content_end -->
			<!-- footer_start -->
			<div style="margin: 10px 15px 0px 15px; padding-bottom: 20px; font-family: nanumgothic; font-size: 11px; line-height: 20px;">
				<div>
					<table border=0 cellspacing=0 cellpadding=0 style="width: 100%; font-family: nanumgothic; font-size: 11px;">
						<tr>
							<td rowspan="5" style="width: 150px;">
								<img src="https://www.amazoncar.co.kr/resources/images/logo_1.png" style="width: 150px; padding-right: 10px;"/>
							</td>
							<td style="width: 55px; text-align: center;">����</td>
							<td style="width: 90px; color: red;">02-757-0802</td>
							<td style="width: 55px; text-align: center;">��ȭ��</td>
							<td style="width: 90px; color: red;">02-2038-8661</td>
							<td style="width: 55px; text-align: center;">����</td>
							<td style="width: 90px; color: red;">02-537-5877</td>
							<td style="width: 55px; text-align: center;">����</td>
							<td style="width: 90px; color: red;">02-2038-2492</td>
						</tr>
						<tr>
							<td style="width: 55px; text-align: center;">��õ</td>
							<td style="width: 90px; color: red;">032-554-8820</td>
							<td style="width: 55px; text-align: center;">����</td>
							<td style="width: 90px; color: red;">031-546-8858</td>
							<td style="width: 55px; text-align: center;">����</td>
							<td style="width: 90px; color: red;">042-824-1770</td>
							<td style="width: 55px; text-align: center;">�뱸</td>
							<td style="width: 90px; color: red;">053-582-2998</td>
						</tr>
						<tr>
							<td style="width: 55px; text-align: center;">�λ�</td>
							<td style="width: 90px; color: red;">051-851-0606</td>
							<td style="width: 55px; text-align: center;">����</td>
							<td colspan="5" style="color: red;">062-385-0133</td>
						</tr>
						<tr>
							<td colspan="8" style="height: 8px;"></td>
						</tr>
						<tr>
							<td style="width: 55px; text-align: center;">������</td>
							<td style="width: 90px; color: red;">02-392-4242</td>
							<td style="width: 55px; text-align: center;">�ѹ�</td>
							<td colspan="5" style="color: red;">02-392-4243</td>
						</tr>
					</table>
				</div>
				<div style="padding: 20px 0px 0px 0px; text-align: center;">
					<span style="font-family: nanumgothic;">
						���� �������� �ǻ���� 8 802 (���ǵ���, �������) | ���θ� : �ֽ�ȸ�� �Ƹ���ī | ��ǥ�̻� : ������
					</span><br>
					<span style="color: #a1a1a2;">Copyright(c) 2004 by amazoncar. All right reserved webmaster@amazoncar.co.kr</span>
				</div>
			</div>
			<!-- footer_end -->
		</div>
	</div>
</div>

</body>
</html>
