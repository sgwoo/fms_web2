<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.pay_mng.*" %>
<jsp:useBean id="sb_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String go_url = request.getParameter("go_url")==null?"N":request.getParameter("go_url");

	CarServDatabase csd = CarServDatabase.getInstance();
	ServiceBean sb_r [] = csd.getServiceAll(car_mng_id);
	long tot_amt = csd.getTot_amt(car_mng_id);
	
	LoginBean login = LoginBean.getInstance();	
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>차량이력내용</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function ServiceDisp(serv_id,serv_st){
		var theForm = document.LoadServiceForm;
		var auth_rw = theForm.auth_rw.value;
		var rent_mng_id = theForm.rent_mng_id.value;
		var rent_l_cd = theForm.rent_l_cd.value;
		var car_mng_id = theForm.car_mng_id.value;
		
		var url = "?auth_rw=" + auth_rw
				+ "&rent_mng_id=" + rent_mng_id 
				+ "&rent_l_cd=" + rent_l_cd
				+ "&car_mng_id=" + car_mng_id
				+ "&serv_id="+ serv_id;	
	

		if(serv_st=="1"){
			theForm.action = "jakup2.jsp"+url;
			theForm.target = 'd_content';	
			theForm.submit();
		}else{
			var SUBWIN="./cus0401_d_sc_carhis_reg2.jsp" + url;
			window.open(SUBWIN, "RoundReg", "left=100, top=110, width=820, height=390, scrollbars=no");
			//theForm.action = "cus0401_d_sc_carhis_reg.jsp"+url;
		}
			
	}
	
	function ServiceDisp_old(serv_id,serv_st){
		var theForm = document.LoadServiceForm;
		var auth_rw = theForm.auth_rw.value;
		var rent_mng_id = theForm.rent_mng_id.value;
		var rent_l_cd = theForm.rent_l_cd.value;
		var car_mng_id = theForm.car_mng_id.value;
		//var car_no = theForm.car_no.value;
		//var firm_nm = theForm.firm_nm.value;
		//var client_nm = theForm.client_nm.value;	
		var url = "?auth_rw=" + auth_rw
				+ "&rent_mng_id=" + rent_mng_id 
				+ "&rent_l_cd=" + rent_l_cd
				+ "&car_mng_id=" + car_mng_id
				//+ "&off_id=" + off_id 
				+ "&serv_id="+ serv_id;	
	
		var SUBWIN="./cus0401_d_sc_carhis_reg_old.jsp" + url;
		window.open(SUBWIN, "RoundReg2", "left=100, top=110, width=820, height=390, scrollbars=no");
	}	
	
	function thisreload(){
		this.reload();
	}
	
	function serv_del(serv_id){
		if(!confirm('해당 정비건을 삭제하시겠습니까?')){ return; }
		var fm = document.LoadServiceForm;
		fm.action = "./cus0401_d_sc_serviceDel.jsp?serv_id="+serv_id;
		fm.target = "i_no";
		fm.submit();
	}
	//정비 등록 팝업윈도우 열기
function serv_reg(car_mng_id, serv_id, go_url){
	var SUBWIN="../cus_reg/serv_reg.jsp?cmd=s&car_mng_id=" + car_mng_id + "&serv_id=" + serv_id + "&go_url=" + go_url; 
	window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=600,top=50,left=50');
}

	//정비 등록 팝업윈도우 열기
function serv_reg1(car_mng_id, serv_id, go_url){
	var SUBWIN="../cus_reg/serv_reg2.jsp?car_mng_id=" + car_mng_id + "&serv_id=" + serv_id + "&go_url=" + go_url; 
	window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=600,top=50,left=50');
}

//-->
</script>
</head>

<body>
<form action="cu0401_carhis_in.jsp" name="LoadServiceForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="rent_mng_id" value="<%= rent_mng_id %>">
<input type="hidden" name="rent_l_cd" value="<%= rent_l_cd %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
          <%for(int i=0; i<sb_r.length; i++){
				sb_bean = sb_r[i];%>
                <tr> 
                    <td width=5% align=center><%= i+1 %></td>
                    <td width=10% align=center><%=AddUtil.ChangeDate2(sb_bean.getServ_dt())%></td>
                    <td width=10% align=center><a href="javascript:serv_reg('<%=sb_bean.getCar_mng_id()%>','<%= sb_bean.getServ_id() %>', '<%=go_url%>')"><%=sb_bean.getServ_st_nm()%></a>
                    <% if ( ck_acar_id.equals("000063") ) {%><a href="javascript:serv_reg1('<%=sb_bean.getCar_mng_id()%>','<%= sb_bean.getServ_id() %>', '<%=go_url%>')">.</a><%} %>
                    </td>
                    <td width=10% align=center> 
                      <%if(!sb_bean.getChecker().equals("")){
        													if(sb_bean.getChecker().substring(0,2).equals("00")){%>
                      <%= login.getAcarName(sb_bean.getChecker()) %> 
                      <%}else{%>
                      <%= sb_bean.getChecker() %> 
                      <% }
        												}%>
                    </td>
                    <%if(AddUtil.toString(sb_bean.getCar_comp_id()).equals("0041")){%>
                    <td width=15%>&nbsp;&nbsp;<font color="red"><%=Util.subData(sb_bean.getOff_nm(),10)%></font></td>
					<%}else if(AddUtil.toString(sb_bean.getCar_comp_id()).equals("0043")){%>
                    <td width=15%>&nbsp;&nbsp;<font color="blue"><%=Util.subData(sb_bean.getOff_nm(),10)%></font></td>
                    <%}else{%>
                    <td width=15%>&nbsp;&nbsp;<span title="<%=sb_bean.getOff_nm()%>"><%=Util.subData(sb_bean.getOff_nm(),10)%></span></td>
                    <%}%>
                    <td align=left width=25%> 
                      <% if(!sb_bean.getServ_dt().equals("")){ 
        			  		if((sb_bean.getServ_st().equals("2")||sb_bean.getServ_st().equals("3"))&&(AddUtil.parseInt(sb_bean.getServ_dt())>20031231)){ %>
                      &nbsp;[순회] 
                      <%	}
        			  } %>
                      <%if((sb_bean.getServ_st().equals("2")||sb_bean.getServ_st().equals("3"))&&(AddUtil.parseInt(sb_bean.getServ_dt())>20031231)){%>
        						 <span title="<%ServItem2Bean si_r [] = csd.getServItem2All(sb_bean.getCar_mng_id(), sb_bean.getServ_id());
                    							for(int j=0; j<si_r.length; j++){
        		            						si_bean = si_r[j];
        				    						if(j==si_r.length-1){
                    									out.print(si_bean.getItem());
                    								}else{
                    									out.print(si_bean.getItem()+",");
                    								}            	
                    							}%>">										
        					<%}else{%>
        					&nbsp;<span title="<%= sb_bean.getRep_cont() %>">
        					<%}%> 
                      <%if((sb_bean.getServ_st().equals("2")||sb_bean.getServ_st().equals("3"))&&(AddUtil.parseInt(sb_bean.getServ_dt())>20031231)){
        					ServItem2Bean si_r [] = csd.getServItem2All(sb_bean.getCar_mng_id(), sb_bean.getServ_id());
        					for(int j=0; j<si_r.length; j++){
        						si_bean = si_r[j];
        						if(j==0){%>
        						  <%=si_bean.getItem()%><% if(si_r.length>1){ %>외 <font color="red"><%=si_r.length-1%></font>건 <% } %> 
        						<%}
        					}
           				
        				}else{%>
        					<%=Util.subData(sb_bean.getRep_cont(),15)%>		
        			<%  } %>
                      </span> </td>
                    <td width=10% align=right><%=Util.parseDecimal(sb_bean.getTot_dist())%> 
                      km&nbsp;</td>
                    <td width=10% align=right><%=Util.parseDecimal(sb_bean.getTot_amt())%>원&nbsp;</td>
                    <td width=5% align=center>
         <%           
                    //출금원장
		Hashtable serv_pay = ps_db.getPayServ(sb_bean.getCar_mng_id(), sb_bean.getServ_id());
		String serv_pay_dt = (String)serv_pay.get("P_PAY_DT")==null?"":(String)serv_pay.get("P_PAY_DT");
		String serv_reg_st = (String)serv_pay.get("SERV_REG_ST")==null?"":(String)serv_pay.get("SERV_REG_ST");
         %>	
                  	
		  <%if( ( sb_bean.getJung_st().equals("")  && !sb_bean.getSac_yn().equals("Y") )  || (  (serv_reg_st.equals("Y") || serv_reg_st.equals("S") ) &&serv_pay_dt.equals("")   )    ){%>
					  <a href="javascript:serv_del('<%=sb_bean.getServ_id()%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
					  <%}%>
					  
					  </td>
                </tr>
          <%}%>
		        <tr>
                    <td width=5% class="title">&nbsp;</td>
                    <td width=10% class="title">&nbsp;</td>
                    <td width=10% class="title">&nbsp;</td>
                    <td width=10% class="title">&nbsp;</td>
                    <td width=15% class="title" align="right">정비비합계</td>
                    <td width=25% class="title">&nbsp;</td>
                    <td  colspan="2" class="title"  style="text-align:right"><%= AddUtil.parseDecimal(tot_amt) %>원&nbsp;</td>
                    <td width=5% class="title">&nbsp;</td>
                </tr>
          <% if(sb_r.length == 0) { %>
                <tr> 
                    <td align=center height=25 colspan="9">등록된 데이타가 없습니다.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
