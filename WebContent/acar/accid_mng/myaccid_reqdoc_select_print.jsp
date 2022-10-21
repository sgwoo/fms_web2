<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String seq_no 	= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");//사고관리일련번호
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");//고객관리번호
	String cust_id= request.getParameter("cust_id")==null?"":request.getParameter("cust_id");//고객관리번호
	
	System.out.println("[휴/대차료 청구필요서류 일괄인쇄] c_id="+c_id+", accid_id="+accid_id+", user_id="+user_id);
	
	
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

// 쿠키 가져오기
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
		


<%		if(doc_gubun.equals("D01")){//아마존카 사업자등록증 사본
			String file = request.getParameter("D01_file")==null?"":request.getParameter("D01_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D02")){//아마존카 단기대여요금표
			String file = request.getParameter("D02_file")==null?"":request.getParameter("D02_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D03")){//아마존카 신한은행 통장사본
			String file = request.getParameter("D03_file")==null?"":request.getParameter("D03_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D04")){//대차료청구소송 1심판결문 1page
			String file = request.getParameter("D04_file")==null?"":request.getParameter("D04_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D05")){//대차료청구소송 1심판결문 2page
			String file = request.getParameter("D05_file")==null?"":request.getParameter("D05_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D06")){//대차료청구소송 1심판결문 3page
			String file = request.getParameter("D06_file")==null?"":request.getParameter("D06_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("D07")){//대차료청구소송 2심판결문
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


<%		if(doc_gubun.equals("LCO")){//사고차량 보유차운영 서비스 계약서
			String LCO_cid = request.getParameter("LCO_cid")==null?"":request.getParameter("LCO_cid");
			String LCO_scd = request.getParameter("LCO_scd")==null?"":request.getParameter("LCO_scd");
			String LCO_rent_st = request.getParameter("LCO_rent_st")==null?"":request.getParameter("LCO_rent_st");
			%>
<br>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<!-- 대차차량 사고대차 서비스 계약서 -->		
			<jsp:include page="/acar/rent_mng/res_rent_u_accid_print.jsp" flush="true">
                    <jsp:param name="mode" value="res_doc"/>
					<jsp:param name="c_id" value="<%=LCO_cid%>"/>
                    <jsp:param name="s_cd" value="<%=LCO_scd%>"/>
					<jsp:param name="sub_c_id" value="<%=c_id%>"/>
                    <jsp:param name="accid_id" value="<%=accid_id%>"/>
                    <jsp:param name="seq_no" value="<%=seq_no%>"/>
            </jsp:include>			
            <!-- 대차차량 사고대차 서비스 계약서 -->		
		</td>
	</tr>
</table>
<%			if(LCO_rent_st.equals("4")){//업무대여%>
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


<%		if(doc_gubun.equals("S17")){//대여개시후계약서(앞)
			String file = request.getParameter("S17_file")==null?"":request.getParameter("S17_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("S18")){//대여개시후계약서(뒤)
			String file = request.getParameter("S18_file")==null?"":request.getParameter("S18_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("S01")){//사고차량 최초계약서
			String file = request.getParameter("S01_file")==null?"":request.getParameter("S01_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("LCA")){//사고차량 자동차등록증
			String file = request.getParameter("LCA_file")==null?"":request.getParameter("LCA_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("SCO")){//대차차량 사고대차 서비스 계약서
			String SCO_cid = request.getParameter("SCO_cid")==null?"":request.getParameter("SCO_cid");
			String SCO_scd = request.getParameter("SCO_scd")==null?"":request.getParameter("SCO_scd");%>
<br>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<!-- 대차차량 사고대차 서비스 계약서 -->		
			<jsp:include page="/acar/rent_mng/res_rent_u_accid_print.jsp" flush="true">
                    <jsp:param name="mode" value="accid_doc"/>
					<jsp:param name="c_id" value="<%=SCO_cid%>"/>
                    <jsp:param name="s_cd" value="<%=SCO_scd%>"/>
					<jsp:param name="sub_c_id" value="<%=c_id%>"/>
                    <jsp:param name="accid_id" value="<%=accid_id%>"/>
                    <jsp:param name="seq_no" value="<%=seq_no%>"/>
            </jsp:include>			
            <!-- 대차차량 사고대차 서비스 계약서 -->		
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


<%		if(doc_gubun.equals("SCI")){//대차차량 사고대차 서비스 임의계약서
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
			<!-- 대차차량 사고대차 서비스 계약서 -->		
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
            <!-- 대차차량 사고대차 서비스 계약서 -->		
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


<%		if(doc_gubun.equals("SCA")){//대차차량 자동차등록증
			String file = request.getParameter("SCA_file")==null?"":request.getParameter("SCA_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>


<%		if(doc_gubun.equals("ITE")){//거래명세서
			String item_id = request.getParameter("ITE_item_id")==null?"":request.getParameter("ITE_item_id");%>
<br>
<br>
<br>
<br>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<!-- 거래명세서 -->		
			<jsp:include page="/tax/item_mng/doc_accid_print_t.jsp" flush="true">
                    <jsp:param name="mode" value="accid_doc"/>			
                    <jsp:param name="item_id" value="<%=item_id%>"/>
					<jsp:param name="client_id" value="<%=client_id%>"/>
                    <jsp:param name="car_mng_id" value="<%=c_id%>"/>
                    <jsp:param name="accid_id" value="<%=accid_id%>"/>
            </jsp:include>			
            <!-- 거래명세서 -->		
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


<%		if(doc_gubun.equals("TAX")){//세금계산서
			String item_id = request.getParameter("TAX_item_id")==null?"":request.getParameter("TAX_item_id");%>
<br>
<br>
<br>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<!-- 세금계산서 -->		
			<jsp:include page="/tax/tax_mng/tax_accid_print_t.jsp" flush="true">
                    <jsp:param name="mode" value="accid_doc"/>			
                    <jsp:param name="item_id" value="<%=item_id%>"/>
					<jsp:param name="client_id" value="<%=client_id%>"/>
                    <jsp:param name="car_mng_id" value="<%=c_id%>"/>
                    <jsp:param name="accid_id" value="<%=accid_id%>"/>
            </jsp:include>			
            <!-- 세금계산서 -->		
		</td>
	</tr>
</table>
<%		}%>

<%		if(doc_gubun.equals("SCN")){//대차차량 계약서 스캔파일
			String file = request.getParameter("SCN_file")==null?"":request.getParameter("SCN_file");%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr<%=file%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>

<%		if(doc_gubun.equals("SCN2")){//대차차량 계약서 스캔파일
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
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 10.0; //좌측여백   
factory.printing.topMargin = 10.0; //상단여백    
factory.printing.rightMargin = 10.0; //우측여백
factory.printing.bottomMargin = 10.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>
