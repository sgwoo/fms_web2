<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String seq_no 	= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");//�������Ϸù�ȣ
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");//��������ȣ
	String cust_id= request.getParameter("cust_id")==null?"":request.getParameter("cust_id");//��������ȣ
	
	System.out.println("[��/������ û���ʿ伭�� �ϰ��μ�] c_id="+c_id+", accid_id="+accid_id+", user_id="+user_id);
	
	
	String vid[] = request.getParameterValues("ch_cd");
	String doc_gubun = "";
	
	int img_width 	= 680;
	int img_height 	= 1009;
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>

<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>

<script>

window.onbeforeprint = function(){
	//setCookie();
};

function setCookie(cName, cValue, cMinutes){

 	var expire = new Date();
    expire.setDate(expire.getMinutes() + cMinutes);
    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr';
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
    
}

// ��Ű ��������
function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}

setCookie('tmp_waste', 'delete', 1);

</script>

</head>
<body>
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/ScriptX.cab" > 
</object> 
<%	for(int i=0; i < vid.length; i++){
		doc_gubun = vid[i];%>
		


<%		if(doc_gubun.equals("D01")){//�Ƹ���ī ����ڵ���� �纻
			String file = request.getParameter("D01_file")==null?"":request.getParameter("D01_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D02")){//�Ƹ���ī �ܱ�뿩���ǥ
			String file = request.getParameter("D02_file")==null?"":request.getParameter("D02_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D03")){//�Ƹ���ī �������� ����纻
			String file = request.getParameter("D03_file")==null?"":request.getParameter("D03_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D04")){//������û���Ҽ� 1���ǰṮ 1page
			String file = request.getParameter("D04_file")==null?"":request.getParameter("D04_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D05")){//������û���Ҽ� 1���ǰṮ 2page
			String file = request.getParameter("D05_file")==null?"":request.getParameter("D05_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D06")){//������û���Ҽ� 1���ǰṮ 3page
			String file = request.getParameter("D06_file")==null?"":request.getParameter("D06_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D07")){//������û���Ҽ� 2���ǰṮ
			String file = request.getParameter("D07_file")==null?"":request.getParameter("D07_file");
			for(int j=0; j<14; j++){%>
			
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr/data/doc/S36BW-412010410590_00<%=AddUtil.addZero2(j+1)%>.jpg" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>	
<%			}
		}%>


<%		if(doc_gubun.equals("LCO")){//������� ������� ���� ��༭
			String LCO_cid = request.getParameter("LCO_cid")==null?"":request.getParameter("LCO_cid");
			String LCO_scd = request.getParameter("LCO_scd")==null?"":request.getParameter("LCO_scd");
			String LCO_rent_st = request.getParameter("LCO_rent_st")==null?"":request.getParameter("LCO_rent_st");
			%>
<br>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<!-- �������� ������ ���� ��༭ -->		
			<jsp:include page="/acar/rent_mng/res_rent_u_accid_print.jsp" flush="true">
                    <jsp:param name="mode" value="res_doc"/>
					<jsp:param name="c_id" value="<%=LCO_cid%>"/>
                    <jsp:param name="s_cd" value="<%=LCO_scd%>"/>
					<jsp:param name="sub_c_id" value="<%=c_id%>"/>
                    <jsp:param name="accid_id" value="<%=accid_id%>"/>
                    <jsp:param name="seq_no" value="<%=seq_no%>"/>
            </jsp:include>			
            <!-- �������� ������ ���� ��༭ -->		
		</td>
	</tr>
</table>
<%			if(LCO_rent_st.equals("4")){//�����뿩%>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<%			}%>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<%		}%>


<%		if(doc_gubun.equals("S17")){//�뿩�����İ�༭(��)
			String file = request.getParameter("S17_file")==null?"":request.getParameter("S17_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("S18")){//�뿩�����İ�༭(��)
			String file = request.getParameter("S18_file")==null?"":request.getParameter("S18_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("S01")){//������� ���ʰ�༭
			String file = request.getParameter("S01_file")==null?"":request.getParameter("S01_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("LCA")){//������� �ڵ��������
			String file = request.getParameter("LCA_file")==null?"":request.getParameter("LCA_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("SCO")){//�������� ������ ���� ��༭
			String SCO_cid = request.getParameter("SCO_cid")==null?"":request.getParameter("SCO_cid");
			String SCO_scd = request.getParameter("SCO_scd")==null?"":request.getParameter("SCO_scd");%>
<br>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<!-- �������� ������ ���� ��༭ -->		
			<jsp:include page="/acar/rent_mng/res_rent_u_accid_print.jsp" flush="true">
                    <jsp:param name="mode" value="accid_doc"/>
					<jsp:param name="c_id" value="<%=SCO_cid%>"/>
                    <jsp:param name="s_cd" value="<%=SCO_scd%>"/>
					<jsp:param name="sub_c_id" value="<%=c_id%>"/>
                    <jsp:param name="accid_id" value="<%=accid_id%>"/>
                    <jsp:param name="seq_no" value="<%=seq_no%>"/>
            </jsp:include>			
            <!-- �������� ������ ���� ��༭ -->		
		</td>
	</tr>
</table>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<%		}%>


<%		if(doc_gubun.equals("SCI")){//�������� ������ ���� ���ǰ�༭
			String SCO_cid = request.getParameter("SCI_cid")==null?"":request.getParameter("SCI_cid");
			String res_client_id = client_id;
			String res_client_st = request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
			if(!cust_id.equals("")){
				res_client_id = cust_id;
			}
			%>
<br>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<!-- �������� ������ ���� ��༭ -->		
			<jsp:include page="/acar/rent_mng/res_rent_u_accid_im_print.jsp" flush="true">
                    <jsp:param name="mode" value="accid_doc"/>
					<jsp:param name="c_id" value="<%=SCO_cid%>"/>
                    <jsp:param name="s_cd" value=""/>
					<jsp:param name="sub_c_id" value="<%=c_id%>"/>
                    <jsp:param name="accid_id" value="<%=accid_id%>"/>
                    <jsp:param name="seq_no" value="<%=seq_no%>"/>
					<jsp:param name="client_id" value="<%=res_client_id%>"/>
					<jsp:param name="client_st" value="<%=res_client_st%>"/>
            </jsp:include>			
            <!-- �������� ������ ���� ��༭ -->		
		</td>
	</tr>
</table>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<%		}%>


<%		if(doc_gubun.equals("SCA")){//�������� �ڵ��������
			String file = request.getParameter("SCA_file")==null?"":request.getParameter("SCA_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("ITE")){//�ŷ�����
			String item_id = request.getParameter("ITE_item_id")==null?"":request.getParameter("ITE_item_id");%>
<br>
<br>
<br>
<br>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<!-- �ŷ����� -->		
			<jsp:include page="/tax/item_mng/doc_accid_print_t.jsp" flush="true">
                    <jsp:param name="mode" value="accid_doc"/>			
                    <jsp:param name="item_id" value="<%=item_id%>"/>
					<jsp:param name="client_id" value="<%=client_id%>"/>
                    <jsp:param name="car_mng_id" value="<%=c_id%>"/>
                    <jsp:param name="accid_id" value="<%=accid_id%>"/>
            </jsp:include>			
            <!-- �ŷ����� -->		
		</td>
	</tr>
</table>
<br>
<br>
<br>
<br>
<br>
<br>


<%		}%>


<%		if(doc_gubun.equals("TAX")){//���ݰ�꼭
			String item_id = request.getParameter("TAX_item_id")==null?"":request.getParameter("TAX_item_id");%>
<br>
<br>
<br>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<!-- ���ݰ�꼭 -->		
			<jsp:include page="/tax/tax_mng/tax_accid_print_t.jsp" flush="true">
                    <jsp:param name="mode" value="accid_doc"/>			
                    <jsp:param name="item_id" value="<%=item_id%>"/>
					<jsp:param name="client_id" value="<%=client_id%>"/>
                    <jsp:param name="car_mng_id" value="<%=c_id%>"/>
                    <jsp:param name="accid_id" value="<%=accid_id%>"/>
            </jsp:include>			
            <!-- ���ݰ�꼭 -->		
		</td>
	</tr>
</table>
<%		}%>

<%		if(doc_gubun.equals("SCN")){//�������� ��༭ ��ĵ����
			String file = request.getParameter("SCN_file")==null?"":request.getParameter("SCN_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>

<%		if(doc_gubun.equals("SCN2")){//�������� ��༭ ��ĵ����
			String file = request.getParameter("SCN2_file")==null?"":request.getParameter("SCN2_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>

<%	}%>


</body>
</html>
<script>
onprint();

function onprint(){
	
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}	

function IE_Print() {
factory.printing.header = ""; //��������� �μ�
factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 10.0; //��������   
factory.printing.topMargin = 10.0; //��ܿ���    
factory.printing.rightMargin = 10.0; //��������
factory.printing.bottomMargin = 10.0; //�ϴܿ���
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>
