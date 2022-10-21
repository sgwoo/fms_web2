<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.client.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<% 
	String pay_way 		= request.getParameter("pay_way")			==null? "":request.getParameter("pay_way");
	
	String var2 = request.getParameter("var2")==null?"":request.getParameter("var2");	
	String var4 = request.getParameter("var4")==null?"":request.getParameter("var4");	
	String var5 = request.getParameter("var5")==null?"":request.getParameter("var5");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
		
	String client_id = var5;
	String rent_l_cd = var2;		
	String rent_mng_id = var4;
		
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	//���������
	UsersBean user_bean = umd.getUsersBean(base.getBus_id2());
	
	//���� �������� ��ü����� fetch
	Vector vt = a_db.getContListForClient(client_id);
	int vt_size = vt.size();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>    
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script language='JavaScript' src='https://fms1.amazoncar.co.kr/include/common.js'></script>
<style>
	*{
		font-family: serif;
	}
</style>
<style>
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    line-height: 1.8em;
    /* font-family: "���� ���", Malgun Gothic, "����", gulim,"����", dotum, arial, helvetica, sans-serif; */
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    min-height: 297mm;
    padding: 10mm; /* set contents area */
    margin: 10mm auto;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 20px;
   /*  border: 1px #888 solid ; */
    height: 273mm;
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
        height: 297mm;
        background: #fff;
    }
    .paper {
        margin: 0;
        border: initial;
        border-radius: initial;
        width: initial;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
   
}
	/* #contents {font-size:9pt}; */

.title{text-align:center;background-color: aliceblue;}  
.contents {font-size:10pt;}
.contents tr{ height:30px;}
/* #wrap{ font-family: 'Malgun Gothic'; vertical-align: middle; font-weight:bold;} */
table, th, td{	border: 1px solid black;  text-align: center; line-height: 30px;}	
table{	border-collapse: collapse;	}
</style>
<script type="text/javascript">
//����뿩�� ���
function set_fee_amt(){
	var pay_way = '<%=pay_way%>';
	var per = 0;
	if(pay_way=="ARS"){			per = 3.2;		}
	else if(pay_way=="visit"){	per = 2.3;		}
	var vt_size = '<%=vt_size%>';
	var sum_amt = 0;
	var sum_amt_r = 0;
	var sum_minus = 0;
	for(var i=0; i<vt_size; i++){
		var format =  Math.round(toInt(parseDigit($("#fee_amt"+i).val() )) * per /100 );
		$("#minus"+i).html(parseDecimal(th_rnd(format)));
		$("#fee_amt_r"+i).html(parseDecimal(th_rnd(format*1+$("#fee_amt"+i).val()*1)));
		sum_amt 		+= $("#fee_amt"+i).val()*1;
		sum_amt_r 	+= format*1+$("#fee_amt"+i).val()*1;
		sum_minus	+= format*1;
	}
	$("#sum_amt").html(parseDecimal(th_rnd(sum_amt)));
	$("#sum_amt_r").html(parseDecimal(th_rnd(sum_amt_r)));
	$("#sum_minus").html(parseDecimal(th_rnd(sum_minus)));
	
	
}
</script>
</head>
<body topmargin=0 leftmargin=0 onLoad="javascript:set_fee_amt();">
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="https://www.amazoncar.co.kr/smsx.cab#Version=6,4,438,06"> 
</object>
<div class="paper">
	<div class="content">
		<div class="wrap" style="width:100%;">
			<div id="print_template_a">
				<div><img src="https://fms1.amazoncar.co.kr/acar/images/logo_doc.png"></div>
				<div align="right" >07236 ����� �������� �ǻ���� 8 (������� 802ȣ)</div>
				<div align="right">T) 02-392-4243, F) 02-757-0803</div>
				<div align="right">Ȩ������ https://www.amazoncar.co.kr</div>
			</div>
			<hr><br>
			<div style="font-weight:bold;">
				<div>���� : <%=client.getFirm_nm()%> ����</div>
				<div>���� : �ڵ��� ���뿩 �뿩���� �������� �ȳ�</div>
			</div>
			<br>
			<hr>
			<div style="font-weight:bold;">
				<br>
				<div>1. <%=client.getFirm_nm()%> ����, ���� �ŷ��� �������� ���� �����帮��, ������ ���� ��â�Ͻ��� ����մϴ�.</div>	
				<div>2. ���Բ��� �̿��ϰ� ��� �ڵ��� �뿩�� ���Ҽ��ܰ� ������ ���ǿ� ������ ���� �ȳ��� ���� �帳�ϴ�.</div>
				<br>
				<div>�� ��� �뿩����� CMS(���������� �ڵ���ü) ������ ������������ ������ ����ϰ� ������ ����(�����ŷ����¹�ȣ ����)�Ͽ� ����� ü���Ͽ����ϴ�
						(÷�� ��༭ �纻 ����).</div>
				<div>���� ������ �̿��ϰ� ��� �ڵ��� �뿩��� ������ ���� ���¿��� �ſ� �����Ͽ� CMS�ý����� �̿��� ����� ���� ���¿� �ڵ����� �Ա��ϰڴٴ� ��ӿ� ���� 
						CMS �������ο���Դϴ�.</div>
				<br> 
				<div>�� CMS(���������� �ڵ���ü)�� ���ݾ����� �ý���ȭ�ϰ� �ּ��� ������� ������ �� �� �ִٴ� ������ �ֽ��ϴ�.</div>
 				<div>���� �װ����� ���� ���������׸�ŭ�� ���԰� ������ �뿩�ῡ �ݿ��� �����ص帰 ���Դϴ�.</div>
 				<div>�ݸ鿡 ��ȭ(����)�� ����������İ� �ſ�ī�������� ���� CMS�ý��� �̿��� ��� ���� �߰����� ������ ������ �䱸�ǰ� ������ ������ �ʿ��մϴ�.</div>
 				<div>�̷��� ������Ŀ� ���� ������ ���̰� �����Ƿ� CMS��������� �̿��ϴ� ���ǿ� ������ ���� �ٰŷ� �ռ� ������ �뿩�Ḧ �ٸ� ������Ŀ����� �״�� �����ϱ�� 
 						��ƽ��ϴ�. </div>
				<div>�׷��Ƿ� ������ ��縦 �湮�� ����â���� ��ȭ(����)�� �����Ͻðų� �ſ�ī��� ���������� �����Ͻð� �Ǹ� ������ ��� ��� ���� �뿩�� ���ξ�(CMS�̿���������) 
						��ŭ�� ȯ���Ͽ� �ٽ� ����� ������ �뿩��� ������ �ϼž߸� �ϴ� ���Դϴ�.</div>
			</div>
		</div>
	</div>
</div>
<!-- page2 -->					
<div class="paper">
	<div class="content">
		<div class="wrap" style="width:100%; font-weight: bold;">				
				<div>�� ȯ���Ͽ� ����� ������ �뿩��� ��ȭ�� ��� ����â���� ���������ϴ� ��İ� �ſ�ī��� �����ϴ� ����� �������� ������ �Ȱ��� �ݾ��� �����ϰ� �ֽ��ϴ�.</div>
				<br>
				<div>�� ����� ���� ��� ���԰� ���뿩 ���ü�� ������ CMS(���������� �ڵ���ü)�� �̿��ϴ� ���ǿ� ������ ����(�ŷ�����������¹�ȣ����)�� �־�߸� 
						���ü���� �����ϴٴ� ���� ��Ģ���� ��� �ֽ��ϴ�.</div>
			<br>
			<div>�� �� �뿩��� �Ʒ��� �����ϴ�. (���� : ��)</div>
			<div align="center">
				<table width="95%">
					<tr>
						<td rowspan="2">����</td>
						<td colspan="3">�� �뿩��</td>
						<td rowspan="2">���</td>
					</tr>
					<tr>	
						<td>���� �뿩��</td>
						<td>���� �뿩��</td>
						<td>����</td>
					</tr>
<%	if(vt_size >0){
			for(int i=0; i<vt_size;i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
%>					
					<tr>
						<td><%=ht.get("CAR_NO")%></td>
						<td>
							<%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>
							<input type="hidden" id="fee_amt<%=i%>" value="<%=ht.get("FEE_AMT")%>">
						</td>
						<td><span id="fee_amt_r<%=i%>"></span></td>
						<td>�� <span id="minus<%=i%>"></span></td>
						<td></td>
					</tr>
<%		}
		}	 %>
					<tr>
						<td>�հ�</td>
						<td><span id="sum_amt"></span></td>
						<td><span id="sum_amt_r"></span></td>
						<td>�� <span id="sum_minus"></span></td>
						<td></td>
					</tr>
				</table>
			</div>
			<br>
			<div>��� : <%=user_bean.getDept_nm()%>&nbsp;<%=user_bean.getUser_pos()%>&nbsp;<%=user_bean.getUser_nm()%>(<%=user_bean.getUser_m_tel()%>)</div>
			<br><br><br><br>			
			<div align="center">
				<img src="https://fms1.amazoncar.co.kr/acar/main_car_hp/images/ceo_no_stamp.gif" width="400">
				<img src="https://fms1.amazoncar.co.kr/acar/main_car_hp/images/ceo_stamp.jpg" height="90" width="90" style="">
			</div>				
		</div>
	</div>
</div>
</body>
<script>

</script>
</html>