<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String est_id 		= request.getParameter("est_id")==null?"0606J0366":request.getParameter("est_id");
	String car_mng_id 	= request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id");

	
	//차량정보
	Hashtable res = shDb.getCarInfo(car_mng_id);

	//CAR_NM : 차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	cm_bean = a_cmb.getCarNmCase((String)res.get("CAR_ID"), (String)res.get("CAR_SEQ"));
	
	String car_b_inc_name = a_cmb.getCar_b_inc_name(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	
	
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>차량 상세정보</title>

<link rel="stylesheet" type="text/css" href="/acar/main_car_hp/layout.css" />
<link rel="stylesheet" type="text/css" href="/acar/main_car_hp/style.css" />
<script language="JavaScript" type="text/JavaScript">
<!--
//팝업창 닫기
function Close()
{
	self.close();
	window.close();
}

	//해당 차량 상위차종 기본사양 보기
	function open_car_b(car_id, car_seq, car_name){
		fm = document.form1;
		window.open('/acar/car_rent/car_b.jsp?car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b", "left=100, top=100, width=680, height=500, scrollbars=auto"); 
	}
//-->
</script>
<style>
<!--
.style1 {color: #585858}
.style7 {color: #919191; font-size:12px;}
.style8 {color: #ff1515;}

-->
</style>

</head>
<body style="background-image:none;">
<form name="form1" method="post">
<div id="contentsWrap" style="font-size:12px;width:730px;">
	<div >
		<p class="title" style="font-size: 2.0em;padding:20px;">&nbsp;<%=res.get("CAR_NM")+" - "+res.get("CAR_NAME")%> 상세사양</p>
	</div>
<div style="margin-left:5px;">
	<ul>
		<li class="article">
			<table class="type13" width="700px" style="margin-bottom:0px;">
				<tbody>
					<tr>
						<th width="12%" style="background-color:#e6e6e6; border-top:1px solid #dbdbdb;padding: 10px;" >기본사양품목</th>
						<td width="*" style="border-top:1px solid #dbdbdb; padding: 10px;">
						<span class=style1>
						<% if(!car_b_inc_name.equals("")){ %> <a href="javascript:open_car_b('<%= cm_bean.getCar_b_inc_id() %>','<%= cm_bean.getCar_b_inc_seq() %>','<%= car_b_inc_name %>');"  onMouseOver="window.status=''; return true"><%= car_b_inc_name %> 기본사양</a> 외 <br><% } %>
									<%=res.get("CAR_B")%></span>
						</td>
					</tr>
					<tr>
						<th style="background-color:#e6e6e6;padding: 10px;">선택사양품목</th>
						<td style="border-top:1px solid #dbdbdb;padding:10px;">
								<span class=style1>
									<img src=/acar/main_car_hp/images/opt_dot.gif> <%=res.get("OPT")%>
								</span>
						</td>
					</tr>
				</tbody>
			</table>
		</li>
	</ul>
</div>

</div>
<br>

<div style="font-size:1.2em;padding-bottom:15px;"><center><a class="btn_pop" href="javascript:self.close();"><span>닫기</span></a></center></div>
</form>


</body>
</html>

