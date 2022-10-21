<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String save_dt 	= request.getParameter("save_dt")	==null?"":request.getParameter("save_dt");
	String user_nm	= request.getParameter("user_nm")	==null?"":request.getParameter("user_nm");
	String bus_id 	= request.getParameter("bus_id")	==null?"":request.getParameter("bus_id");
	String cs_dt 	= request.getParameter("cs_dt")		==null?"":AddUtil.ChangeString(request.getParameter("cs_dt"));
	String ce_dt 	= request.getParameter("ce_dt")		==null?"":AddUtil.ChangeString(request.getParameter("ce_dt"));
	String bs_dt 	= request.getParameter("bs_dt")		==null?"":AddUtil.ChangeString(request.getParameter("bs_dt"));
	String be_dt 	= request.getParameter("be_dt")		==null?"":AddUtil.ChangeString(request.getParameter("be_dt"));
	
	
	Hashtable ht2 = cmp_db.getCampaignCase_2012_05(save_dt, bus_id);
	
	
	float c_cost_cnt 	= 0.0f;
	float avg_cost_cnt 	= 0.0f;
	float cost_amt 		= 0.0f;
	float sum_cnt 		= 0.0f;
	float f_sum_amt 	= 0.0f;
	float f_sum_amt2 	= 0.0f;
	long sum_amt 		= 0;
	
	
	avg_cost_cnt  = AddUtil.parseFloat((String)ht2.get("AVG_CAR_COST_2"));
	
	
	Vector vt = cmp_db.getStatBusCmpBaseBusCostList(bus_id, "c", bs_dt, be_dt, cs_dt, ce_dt, avg_cost_cnt);
	
	Vector vt2 = cmp_db.getStatBusCmpBaseBusCostListRm(bus_id, "c", bs_dt, be_dt, cs_dt, ce_dt, avg_cost_cnt);
	
		
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	var save_dt = <%=save_dt%>;
	
	//마감보기
	function view_sale_cost_lw_base(rent_mng_id, rent_l_cd, rent_st){
		var height = <%=s_height%>;
		window.open("/fms2/mis/view_sale_cost_cont_lw_base.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st, "VIEW_SALE_COST_LW", "left=0, top=0, width=850, height="+height+", scrollbars=yes");
	}	

	//마감보기
	function view_sale_cost_lw_add(rent_mng_id, rent_l_cd, rent_st){
		var height = <%=s_height%>;
		window.open("/fms2/mis/view_sale_cost_cont_lw_add.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&add_rent_st="+rent_st, "VIEW_SALE_COST_LW", "left=0, top=0, width=850, height="+height+", scrollbars=yes");
	}	

	//마감보기
	function view_sale_cost_lw_rm(rent_mng_id, rent_l_cd, rent_st){
		var height = <%=s_height%>;
		window.open("/fms2/mis/view_sale_cost_cont_lw_rm.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st, "VIEW_SALE_COST_LW", "left=0, top=0, width=850, height="+height+", scrollbars=yes");
	}	

	//마감보기
	function view_sale_cost_lw_base_all(){
		var height = 500;
		var width = <%=s_width%>;
		window.open("/fms2/mis/sale_cost_mng_sc_in.jsp?gubun1=1&gubun2=5&s_kd=4&t_wd=<%=user_nm%>&sort=6&mode=cmp", "VIEW_SALE_COST_LIST", "left=0, top=300, width="+width+", height="+height+", scrollbars=yes");
	}	
	
	function cmp_help_cont(){
		var SUBWIN= "/fms2/mis/view_sale_cost_help.jsp";
		window.open(SUBWIN, "View_Help", "left=50, top=50, width=820, height=700, resizable=yes, scrollbars=yes");
	}		
//-->
</script>
</head>

<body>
<table width="990" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
          <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > 영업캠페인 > <span class=style5>영업캠페인 실적</span></span></td>
          <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>
  <tr> 
    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=user_nm%></span></td>
  </tr>
  <tr>
    <td class=line2></td>
  </tr>
  <tr> 
    <td width="970" class="line">
      <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td class="title" width="30">연번</td>
          <td class="title" width="120">마감구분</td>		  
          <td class="title" width="100">계약번호</td>
          <td class="title" width="120">상호</td>
          <td class="title" width="90">차량번호</td>		  		  
          <td class="title" width="100">차명</td>		  		  		  
          <td class="title" width="90">기준일자</td>
          <td class="title" width="90">영업효율(a)</td>
          <td class="title" width="90">군별1대당평균<br>영업효율(b)</td>		  
          <td class="title" width="90">영업효율대수<br>(=a/b)</td>		  		  
	  <td class="title" width="50">보기</td>
        </tr>
        <%	if(vt.size()+vt2.size()>0){%>
	<%		for(int i=0; i<vt.size(); i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				cost_amt = AddUtil.parseFloat((String)ht.get("COST_AMT")) / avg_cost_cnt;
	%>
        <tr> 
          <td align="center"><%= i+1 %></td>
          <td align="center"><%= ht.get("CMP_ST_NM") %></td>		  
          <td align="center"><%= ht.get("RENT_L_CD") %></td>
          <td>&nbsp;<%= ht.get("FIRM_NM") %></td>
          <td align="center"><%= ht.get("CAR_NO") %></td>		  
          <td align="center"><%= ht.get("CAR_NM") %></td>		  		  		  
          <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("CMP_DT")) %></td>
          <td align="right"><%= Util.parseDecimal((String)ht.get("COST_AMT")) %></td>
          <td align="right"><%= Util.parseDecimal(avg_cost_cnt) %></td>		  
          <td align="right"><%= ht.get("COST_CNT") %><br></td>		  		  
	  <td align="center">
	    <%if(String.valueOf(ht.get("COST_ST")).equals("1")){%>
	      <span class="b"><a href="javascript:view_sale_cost_lw_base('<%= ht.get("RENT_MNG_ID") %>', '<%= ht.get("RENT_L_CD") %>', '<%= ht.get("RENT_ST") %>')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
	    <%}else{%>
	      <%if(String.valueOf(ht.get("COST_ST")).equals("2") || String.valueOf(ht.get("COST_ST")).equals("9")){%>
	        <span class="b"><a href="javascript:view_sale_cost_lw_add('<%= ht.get("RENT_MNG_ID") %>', '<%= ht.get("RENT_L_CD") %>', '<%= ht.get("RENT_ST") %>')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
	      <%}else{%>		  
		-
	      <%}%>		  
	    <%}%>
	  </td>
        </tr>
        <% 			
				sum_amt 	= sum_amt 	+ AddUtil.parseLong((String)ht.get("COST_AMT"));
				f_sum_amt2	= f_sum_amt2 	+ AddUtil.parseFloat((String)ht.get("COST_AMT"));
				f_sum_amt 	= f_sum_amt 	+ AddUtil.parseFloat((String)ht.get("COST_CNT"));
			}%>
	<!--월렌트-->		
	<%		for(int i=0; i<vt2.size(); i++){
				Hashtable ht = (Hashtable)vt2.elementAt(i);
				cost_amt = AddUtil.parseFloat((String)ht.get("COST_AMT")) / avg_cost_cnt;
	%>
        <tr> 
          <td align="center"><%= i+1 %></td>
          <td align="center"><%= ht.get("CMP_ST_NM") %></td>		  
          <td align="center"><%= ht.get("RENT_L_CD") %></td>
          <td>&nbsp;<%= ht.get("FIRM_NM") %></td>
          <td align="center"><%= ht.get("CAR_NO") %></td>		  
          <td align="center"><%= ht.get("CAR_NM") %></td>		  		  		  
          <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("CMP_DT")) %></td>
          <td align="right"><%= Util.parseDecimal((String)ht.get("COST_AMT")) %></td>
          <td align="right"><%= Util.parseDecimal(avg_cost_cnt) %></td>		  
          <td align="right"><%= ht.get("COST_CNT") %><br></td>		  		  
	  <td align="center">
	    <%if(String.valueOf(ht.get("COST_ST")).equals("1")){%>
	      <span class="b"><a href="javascript:view_sale_cost_lw_base('<%= ht.get("RENT_MNG_ID") %>', '<%= ht.get("RENT_L_CD") %>', '<%= ht.get("RENT_ST") %>')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
	    <%}else if(String.valueOf(ht.get("COST_ST")).equals("2") || String.valueOf(ht.get("COST_ST")).equals("9")){%>
	        <span class="b"><a href="javascript:view_sale_cost_lw_add('<%= ht.get("RENT_MNG_ID") %>', '<%= ht.get("RENT_L_CD") %>', '<%= ht.get("RENT_ST") %>')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
	    <%}else if(String.valueOf(ht.get("COST_ST")).equals("13")){%>
	        <span class="b"><a href="javascript:view_sale_cost_lw_rm('<%= ht.get("RENT_MNG_ID") %>', '<%= ht.get("RENT_L_CD") %>', '<%= ht.get("RENT_ST") %>')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
	    <%}else{%>		  
		-
	    <%}%>
	  </td>
        </tr>
        <% 			
				sum_amt 	= sum_amt 	+ AddUtil.parseLong((String)ht.get("COST_AMT"));
				f_sum_amt2	= f_sum_amt2 	+ AddUtil.parseFloat((String)ht.get("COST_AMT"));
				f_sum_amt 	= f_sum_amt 	+ AddUtil.parseFloat((String)ht.get("COST_CNT"));
			}%>		
			
        <tr> 
          <td colspan="7" class="title">합계</td>
          <td align="right"><%= Util.parseDecimal(sum_amt) %></td>
          <td align="right"><%= Util.parseDecimal(avg_cost_cnt) %></td>		  
          <td align="right"><%if(avg_cost_cnt>0){%><%=AddUtil.parseFloatCipher(f_sum_amt2/avg_cost_cnt, 2)%><%}%></td>
          <td class="title">&nbsp;</td>		  
        </tr>
        <%	}else{	 %>
        <tr> 
          <td colspan="10"><div align="center">해당 데이터가 없습니다.</div></td>
        </tr>
        <% 	} %>
            </table>
        </td>
        <td width="20"></td>
    </tr>
  <tr> 
    <td align="right">
	  <a href='javascript:cmp_help_cont()' title='설명문'><img src=/acar/images/center/button_exp.gif border=0 align=absmiddle></a>
	  &nbsp;&nbsp;&nbsp;&nbsp;
	  <a href="javascript:view_sale_cost_lw_base_all()">[전체보기]</a>
    </td>
    <td align="right">&nbsp;</td>	
  </tr>	
</table>
<p>
  <font color="#999999" style="font-size : 9pt;">
    <br>
    ♣ 군별1대당영업효율 = 군별영업효율합계/군별영업대수합계
    <br>
  </font>    
</p>
</body>
</html>
