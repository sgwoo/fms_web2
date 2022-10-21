<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<jsp:useBean id="c_bean" class="acar.condition.ConditionBean" scope="page"/>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	String gubun = "1";
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String br_id = "";
	String fn_id = "0";
	String dt = "1";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun") != null)	gubun = request.getParameter("gubun");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	if(request.getParameter("br_id") != null)	br_id = request.getParameter("br_id");
	if(request.getParameter("fn_id") != null ) fn_id = request.getParameter("fn_id");
	
	
	ConditionBean c_r [] = cdb.getRegCondAll2(gubun,dt,ref_dt1,ref_dt2, br_id, fn_id);
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	

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

function CarRegList(rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt)
{
	var theForm = document.CarRegDispForm;
	theForm.rent_mng_id.value = rent_mng_id;
	theForm.rent_l_cd.value = rent_l_cd;
	theForm.car_mng_id.value = car_mng_id;
	theForm.cmd.value = reg_gubun;
	theForm.rpt_no.value = rpt_no;
	theForm.firm_nm.value = firm_nm;
	theForm.client_nm.value = client_nm;
	theForm.imm_amt.value = imm_amt;
	
<% 
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
		//theForm.action = "./register_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}else{
%>
		if(reg_gubun=="id")
		{
			alert("미등록 상태입니다.");
			return;
		}
		//theForm.action = "./register_r_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}
%>
	theForm.target = "d_content"
	theForm.submit();
}

function view_client(rent_mng_id, rent_l_cd, r_st)
{
	var SUBWIN="/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;	
	window.open(SUBWIN, "View_CLIENT", "left=50, top=50, width=820, height=700, resizable=yes, scrollbars=yes");
}
//-->
</script>
</head>

<body>
<form id="form1" action="./register_frame.jsp" name="CarRegDispForm" method="POST">
 <input type='hidden' name='height' id="height" value='<%=height%>'>
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="rpt_no" value="">
<input type="hidden" name="firm_nm" value="">
<input type="hidden" name="client_nm" value="">
<input type="hidden" name="imm_amt" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 230px;">
					<div style="width: 230px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr> 
								<td width=50  class='title title_border'>연번</td>
			            		<td width=100 class='title title_border'>계약번호</td>
								<td width=80  class='title title_border'>계약일</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
						
							 <colgroup>
				       			<col width="200">
				       			<col width="80">
				       			<col width="200">
				       			<col width="100">
				       			<col width="80">
				       			<col width="80">
				       			<col width="80">				       			       				       					       			
				       			<col width="60">
				       			<col width="60">
				       			<col width="60">
												      
				       			<col width="100">
				       			<col width="100">			       			
				       			<col width="60">		       			
				       			<col width="100">
				       					
				       			<col width="100">
				       			<col width="100">				       						       			
				       			<col width="80">		       			
				       			<col width="100">	
				       				   
				       			<col width="200">				       				            			
				       		</colgroup>
												
							<tr>
								<td width=200 rowspan=2 class='title title_border'>상호</td>
			            		<td width=80 rowspan=2 class='title title_border'>계약자</td>			            		
              					<td width=200 rowspan=2 class='title title_border'>차종</td>
              					<td width=100 rowspan=2 class='title title_border'>연료</td>
              					<td width=80 rowspan=2 class='title title_border'>대금결재일</td>
			            		<td width=80 rowspan=2 class='title title_border'>출고요청일</td>
			            		<td width=80 rowspan=2 class='title title_border'>출고예정일</td>
								<td width=60 rowspan=2 class='title title_border'>최초<br>영업자</td>
			            		<td width=60 rowspan=2 class='title title_border'>대여<br>방식</td>
			            		<td width=60 rowspan=2 class='title title_border'>대여<br>기간</td>
			            		<td colspan=4 class='title title_border'>영업사원</td>
			            		<td colspan=4 class='title title_border'>출고사원</td>
			            		<td width=200 rowspan=2 class='title title_border'>출고지연사유</td>			            		
			            	</tr>
			            	<tr>			            		
			            		<td width=100 class='title title_border'>소속사</td>
								<td width=100 class='title title_border'>영업소</td>
			            		<td width=60 class='title title_border'>담당자</td>			            		
               					<td width=100 class='title title_border'>전화번호</td>               					
			            		<td width=100 class='title title_border'>제조사</td>
								<td width=100 class='title title_border'>영업소</td>
			            		<td width=80 class='title title_border'>담당자</td>			            		
              					<td width=100 class='title title_border'>전화번호</td>
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
				<td style="width: 230px;">
					<div style="width: 230px;">
					   <table class="inner_top_table left_fix">  		  
	
<% if(c_r.length != 0){          
    for(int i=0; i<c_r.length; i++){
        c_bean = c_r[i];
%>            			  <tr style="height: 25px;"> 
							 <td width=50 class='center content_border'><%= i+1 %></td>
           					 <td width=100 class='center content_border'><%= c_bean.getRent_l_cd() %></td>
           					 <td width=80 class='center content_border'><%= c_bean.getRent_dt() %></td>
		            	   </tr>
     <%		}%>
			         <%} else  {%>  
				           <tr>
							 <td class='center content_border'>등록된 데이타가 없습니다</td>
						   </tr>	              
				     <%}	%>
						</table>
		           	</div>            
			    </td>
			    
			    <td>			
		     	  <div>
					<table class="inner_top_table table_layout">  
					 	
<% if(c_r.length != 0){    
    for(int i=0; i<c_r.length; i++){
        c_bean = c_r[i];
%>
						<tr style="height: 25px;"> 							
		            		<td width=200 class='left content_border'>&nbsp;<span title="<%= c_bean.getFirm_nm() %>"><a href="javascript:view_client('<%=c_bean.getRent_mng_id()%>','<%=c_bean.getRent_l_cd()%>','<%=c_bean.getR_st()%>')"><%= AddUtil.substringbdot(c_bean.getFirm_nm(),25) %></a></span></td>
		            		<td width=80 class="center content_border"><span title="<%= c_bean.getClient_nm() %>"><%= Util.subData(c_bean.getClient_nm(),4) %></span></td>
		            		
                            <td width=200 class="left content_border">&nbsp;<span title="<%=c_bean.getCar_jnm()+" "+c_bean.getCar_name()%>"><%= AddUtil.substringbdot(c_bean.getCar_jnm()+" "+c_bean.getCar_name(),25) %></span></td>
		            		<td width=100 class="center content_border"><%= c_bean.getEngine_nm() %></td>
		            		<td width=80 class="center content_border"><%= c_bean.getPur_pay_dt() %></td>
		            		<td width=80 class="center content_border"><%= c_bean.getPur_req_dt() %></td>
		            		<td width=80 class="center content_border">
		            		  <%if(c_bean.getDlv_est_dt().equals("")){%>
		            		    <a href="javascript:parent.reg_DlvEstDt('<%=c_bean.getRent_mng_id()%>','<%=c_bean.getRent_l_cd()%>');" class="btn"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
		            		  <%}else{%>
		            		    <a href="javascript:parent.reg_DlvEstDt('<%=c_bean.getRent_mng_id()%>','<%=c_bean.getRent_l_cd()%>');" class="btn"><%= c_bean.getDlv_est_dt() %></a>
		            		  <%}%>
		            		</td>
							<td width=60 class="center content_border"><%= c_bean.getBus_nm() %></td>								
		            		<td width=60 class="center content_border"><%= c_bean.getRent_way_nm() %></td>
		            	
		            		<td width=60 class="center content_border"><%= c_bean.getCon_mon()+" 개월" %></td>
							<td width=100 class="center content_border"><%=c_bean.getCar_off_name1()%></td>
		            		<td width=100 class="center content_border"><%= Util.subData(c_bean.getIn_car_off_nm(), 6)  %></td>
		            		<td width=60 class="center content_border"><%=  c_bean.getIn_emp_nm() %></td>
		            		
                            <td width=100 class="center content_border"><%= Util.subData(c_bean.getIn_car_off_tel(), 10) %></td>
		            		<td width=100 class="center content_border"><%=c_bean.getCar_off_name2()%></td>
							<td width=100 class="center content_border"><%=  Util.subData(c_bean.getOut_car_off_nm(), 6)  %></td>
		            		<td width=80 class="center content_border"><%=  c_bean.getOut_emp_nm() %></td>
		            		
                            <td width=100 class="center content_border"><%=  Util.subData(c_bean.getOut_car_off_tel(),10) %></td>
                            <td width=200 class="center content_border"><span title="<%= c_bean.getDelay_cont() %>"><%= Util.subData(c_bean.getDelay_cont(), 16) %></span></td>
		            	</tr>
 <%		}	%> 		
		      <%} else  {%>  
				       	<tr>
					       <td  colspan="19" class='center content_border'>&nbsp;</td>
					    </tr>	              
			   <%}	%>
				    </table>
			  </div>
			</td>
  		</tr>
		</table>
	</div>
</div>

</form>
</body>
</html>