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
		
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	//담당자정보
	UsersBean user_bean = umd.getUsersBean(base.getBus_id2());
	
	//고객의 진행중인 전체계약을 fetch
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
    /* font-family: "맑은 고딕", Malgun Gothic, "굴림", gulim,"돋움", dotum, arial, helvetica, sans-serif; */
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
//변경대여료 계산
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
				<div align="right" >07236 서울시 영등포구 의사당대로 8 (태흥빌딩 802호)</div>
				<div align="right">T) 02-392-4243, F) 02-757-0803</div>
				<div align="right">홈페이지 https://www.amazoncar.co.kr</div>
			</div>
			<hr><br>
			<div style="font-weight:bold;">
				<div>수신 : <%=client.getFirm_nm()%> 고객님</div>
				<div>제목 : 자동차 장기대여 대여료의 결제수단 안내</div>
			</div>
			<br>
			<hr>
			<div style="font-weight:bold;">
				<br>
				<div>1. <%=client.getFirm_nm()%> 고객님, 당사와 거래에 진심으로 감사 말씀드리며, 고객님의 일익 번창하심을 기원합니다.</div>	
				<div>2. 고객님께서 이용하고 계신 자동차 대여료 지불수단과 관련한 문의에 다음과 같이 안내의 말씀 드립니다.</div>
				<br>
				<div>▣ 당사 대여요금은 CMS(금융결제원 자동이체) 인출을 전제조건으로 원가를 계산하고 고객님의 동의(금융거래계좌번호 기재)하에 계약을 체결하였습니다
						(첨부 계약서 사본 참조).</div>
				<div>따라서 고객님이 이용하고 계신 자동차 대여료는 고객님의 은행 계좌에서 매월 약정일에 CMS시스템을 이용해 당사의 은행 계좌에 자동으로 입금하겠다는 약속에 따른 
						CMS 약정할인요금입니다.</div>
				<br> 
				<div>▣ CMS(금융결제원 자동이체)는 수금업무를 시스템화하고 최소의 비용으로 업무를 할 수 있다는 이점이 있습니다.</div>
 				<div>따라서 그것으로 얻은 원가절감액만큼을 고객님과 약정한 대여료에 반영해 할인해드린 것입니다.</div>
 				<div>반면에 통화(현금)로 직접수납방식과 신용카드결제방식 등은 CMS시스템 이용방식 대비 여러 추가적인 업무와 절차가 요구되고 고비용의 지출이 필요합니다.</div>
 				<div>이렇게 결제방식에 따른 원가에 차이가 있으므로 CMS결제방식을 이용하는 조건에 동의한 것을 근거로 앞서 할인한 대여료를 다른 결제방식에서도 그대로 유지하기는 
 						어렵습니다. </div>
				<div>그러므로 고객님이 당사를 방문해 수납창구에 통화(현금)로 수납하시거나 신용카드로 결제수단을 변경하시게 되면 고객님은 계약 당시 받은 대여료 할인액(CMS이용조건할인) 
						만큼을 환원하여 다시 계산한 할인전 대여료로 결제를 하셔야만 하는 것입니다.</div>
			</div>
		</div>
	</div>
</div>
<!-- page2 -->					
<div class="paper">
	<div class="content">
		<div class="wrap" style="width:100%; font-weight: bold;">				
				<div>▣ 환원하여 계산한 할인전 대여료는 통화로 당사 수납창구에 직접수납하는 방식과 신용카드로 결제하는 방식을 구분하지 않으며 똑같은 금액을 적용하고 있습니다.</div>
				<br>
				<div>▣ 참고로 당사는 모든 고객님과 장기대여 계약체결 이전에 CMS(금융결제원 자동이체)를 이용하는 조건에 고객님의 동의(거래금융기관계좌번호기재)가 있어야만 
						계약체결이 가능하다는 것을 원칙으로 삼고 있습니다.</div>
			<br>
			<div>▣ 월 대여료는 아래와 같습니다. (단위 : 원)</div>
			<div align="center">
				<table width="95%">
					<tr>
						<td rowspan="2">구분</td>
						<td colspan="3">월 대여료</td>
						<td rowspan="2">비고</td>
					</tr>
					<tr>	
						<td>약정 대여료</td>
						<td>변경 대여료</td>
						<td>차액</td>
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
						<td>△ <span id="minus<%=i%>"></span></td>
						<td></td>
					</tr>
<%		}
		}	 %>
					<tr>
						<td>합계</td>
						<td><span id="sum_amt"></span></td>
						<td><span id="sum_amt_r"></span></td>
						<td>△ <span id="sum_minus"></span></td>
						<td></td>
					</tr>
				</table>
			</div>
			<br>
			<div>담당 : <%=user_bean.getDept_nm()%>&nbsp;<%=user_bean.getUser_pos()%>&nbsp;<%=user_bean.getUser_nm()%>(<%=user_bean.getUser_m_tel()%>)</div>
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