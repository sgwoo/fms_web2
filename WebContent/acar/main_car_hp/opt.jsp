<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.estimate_mng.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_mst.CarOptBean" scope="page"/>
<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	String car_id 	= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq 	= request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");		
		
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	if(!est_id.equals("")){

		e_bean		= e_db.getEstimateAllCase(est_id);
		
		car_id = e_bean.getCar_id();
		car_seq = e_bean.getCar_seq();
	}
	
	//CAR_NM : 차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	String car_b_inc_name = a_cmb.getCar_b_inc_name(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	CarOptBean [] co_r = a_cmb.getCarOptList(cm_bean.getCar_comp_id(), cm_bean.getCode(), cm_bean.getCar_id(), cm_bean.getCar_seq(), "");
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
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
		window.open('car_b.jsp?car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b", "left=100, top=100, width=680, height=500, scrollbars=auto"); 
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
		<p class="title" style="font-size: 2.0em;padding:20px;">&nbsp;<%=cm_bean.getCar_nm()+" - "+cm_bean.getCar_name()%> 상세사양</p>
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
							
								<%=AddUtil.ChangeBr(cm_bean.getCar_b())%>&nbsp;</span>
						</td>
					</tr>
					<tr>
						<th style="background-color:#e6e6e6;padding: 10px;">선택사양품목</th>
						<td style="border-top:1px solid #dbdbdb;padding:10px;">
						 <% for(int j=0; j<co_r.length; j++){
									co_bean = co_r[j];
									
									//미사용은 안보여준다
									if(co_bean.getUse_yn().equals("N")) continue;
									
									%>
								<span class=style1>
									<img src=/acar/main_car_hp/images/opt_dot.gif> <%=co_bean.getCar_s()%> : <span class=style8><%=AddUtil.parseDecimal(co_bean.getCar_s_p())%>원</span><br>
									<%if(!co_bean.getOpt_b().equals("")){%>
										<div style="padding-left:15px;"><span class=style7> - <%=co_bean.getOpt_b()%></span></div>
									<%}%>
								</span>
							 <%}%>
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

