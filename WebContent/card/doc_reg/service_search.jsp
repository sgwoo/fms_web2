<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String buy_dt 	= request.getParameter("buy_dt")==null?AddUtil.getDate():request.getParameter("buy_dt");
	String idx1 		= request.getParameter("idx1")==null?"0":request.getParameter("idx1");
		
	//장기계약 리스트 조회
	Vector card_kinds = CardDb.getServiceList("", "", t_wd, buy_dt);
	
	int ck_size = card_kinds.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="service_search.jsp";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	function setCardCode(idx1, rent_mng_id, rent_l_cd, client_id, car_no, first_car_no, car_nm, firm_nm, car_mng_id, serv_id, item , tot_amt){
		var fm = document.form1;
		opener.form1.rent_l_cd[idx1].value 		= rent_l_cd;
		opener.form1.item_name[idx1].value 		= car_no;					
		opener.form1.acct_cont[idx1].value 		= firm_nm + " - " + item + " - " + car_no;		
		opener.form1.serv_id[idx1].value 	    = serv_id;
		opener.form1.firm_nm[idx1].value 	    = firm_nm;
		opener.form1.item_code[idx1].value 		= car_mng_id;
		opener.form1.stot_amt[idx1].value 		= tot_amt;
			
		window.close();	
	}
	
//-->
</script>

</head>
<body>
<form action="./service_search.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>  
  
  <input type="hidden" name="s_kd" value="<%=s_kd%>">  
  <input type="hidden" name="go_url" value="<%=go_url%>">    
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
      <td>
        <input name="t_wd" type="text" class="text" value="<%=t_wd%>" size="50" onKeyDown="javasript:enter()" style='IME-MODE: active'>
        &nbsp;<a href="javascript:Search();" ><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
      <td class="line" >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='8%' class='title'>연번</td>
            <td width='5%' class='title'>구분</td>			
            <td width='15%' class='title'>차량</td>
            <td width='30%' class='title'>상호</td>
            <td width='20%' class='title'>정비업체</td>		
            <td width='13%' class='title'>정비일</td>
            <td width='20%' class='title'>금액</td>
            			
          </tr>
          <%	if(ck_size > 0){
					for (int i = 0 ; i < ck_size ; i++){
						Hashtable card_kind = (Hashtable)card_kinds.elementAt(i);
						
						int our_fault = 0;
						String item1 = "";
						String item2 = "";

						StringTokenizer token1 = new StringTokenizer((String)card_kind.get("ITEM"),"^");

										
						if(!String.valueOf(card_kind.get("ITEM")).equals("1^")){		
						    	while(token1.hasMoreTokens()) {						
							  	 item1 = token1.nextToken().trim();	//
							   	 item2 = token1.nextToken().trim();	//부품									
						    	}					    
						}	 
						   	
					   	int v_cnt =  AddUtil.parseInt((String)card_kind.get("CNT"));
					    our_fault = AddUtil.parseInt ((String)card_kind.get("OUR_FAULT_PER"));
					     
						String item_nm = "";				 	
					 						 	
					 	if(String.valueOf(card_kind.get("CNT")).equals("1")){  	
					 		item_nm = item2;					 	
						}else{
						   	item_nm = Util.subData(item2, 10)+ " 외 " + AddUtil.parseDecimal(v_cnt - 1) + " 건";		  
						}
						
					 	long tot_amt =  AddUtil.parseLong((String)card_kind.get("TOT_AMT"));					 					 	
					 	tot_amt = tot_amt * our_fault/100;
									   
		%>				
						
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center"><%= card_kind.get("USE_YN") %></td>			
            <td align="center">
			<a href="javascript:setCardCode('<%=idx1%>','<%= card_kind.get("RENT_MNG_ID") %>','<%= card_kind.get("RENT_L_CD") %>','<%= card_kind.get("CLIENT_ID") %>','<%= card_kind.get("CAR_NO") %>','<%= card_kind.get("FIRST_CAR_NO") %>','<%= card_kind.get("CAR_NM") %>','<%= card_kind.get("FIRM_NM") %>','<%= card_kind.get("CAR_MNG_ID") %>','<%= card_kind.get("SERV_ID") %>', '<%=item_nm%>', '<%=tot_amt%>')"><%= card_kind.get("CAR_NO") %></a>
			</td>
            <td align="center"><%= card_kind.get("FIRM_NM") %></td>
            <td align="center"><%= card_kind.get("OFF_NM") %></td>
            <td align="center"><%= card_kind.get("SERV_DT") %></td>		
            <td align="right"><%= Util.parseDecimal(tot_amt) %><%if(ck_acar_id.equals("000029")){%>/<%= card_kind.get("TOT_AMT") %>/<%=our_fault%><%}%></td>						
          </tr>
		  <%	}%>
		  <%}else{%>
          <tr>		  
            <td colspan="7" align="center">등록된 데이타가 없습니다.</td>
          </tr>
		  <%}%>		  
        </table>
	</td>
  </tr>
    <tr>
      <td>&nbsp;<font color="#666666">* 구분 : Y 대여 / N 해지 / '' 미결</font>&nbsp;</td>
    </tr>
    <tr>
      <td align="right"><a href="javascript:window.close();"  ><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
  </table>
</form>
</body>
</html>

