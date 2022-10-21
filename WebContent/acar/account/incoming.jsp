<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소

	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");

	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//수금 스케줄 리스트 이동
	function list_move(gubun1, gubun2, gubun3)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = gubun1;
		fm.gubun2.value = gubun2;
		fm.gubun3.value = gubun3;	
		var idx = gubun1;
		if(idx == '1') 		url = "/fms2/con_fee/fee_frame_s.jsp";
		else if(idx == '2'){
			url = "/fms2/con_grt/grt_frame_s.jsp";
			fm.gubun4.value = '';	
		}
		else if(idx == '3') url = "/acar/con_forfeit/forfeit_frame_s.jsp";
		else if(idx == '4') url = "/fms2/con_ins_m/ins_m_frame_s.jsp";
		else if(idx == '5') url = "/acar/con_ins_h/ins_h_frame_s.jsp";
		else if(idx == '6') url = "/fms2/con_cls/cls_frame_s.jsp";		
		else if(idx == '7') url = "/acar/settle_acc/settle_s_frame.jsp";		
		else if(idx == '8') url = "/fms2/con_s_rent/con_s_rent2_frame.jsp";		
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
//-->
</script>
</head>

<body leftmargin=15>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>수금현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료 현황</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" colspan="3" width="16%" class='title' align="center">구분</td>
                    <td colspan="2" width="21%" class='title' align="center">당월</td>
                    <td colspan="2" width="21%" class='title' align="center">당일</td>
                    <td colspan="2" width="21%" class='title' align="center">연체</td>
                    <td colspan="2" width="21%" class='title' align="center">합계(당일+연체)</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                </tr>
          <%	//대여료 현황
	Vector fees = ac_db.getFeeStat(br_id, search_kd, brch_id, bus_id2);
	int fee_size = fees.size();
	IncomingSBean fee1 = new IncomingSBean();
	IncomingSBean fee2 = new IncomingSBean();
	IncomingSBean fee3 = new IncomingSBean();
	IncomingSBean fee4 = new IncomingSBean();
	if(fee_size > 0){
		for (int i = 0 ; i < 4 ; i++){
			IncomingSBean fee = (IncomingSBean)fees.elementAt(i);
			if(i==1) fee1 = fee; //수금
			if(i==2) fee2 = fee; //미수금
			if(i==3) fee3 = fee; //비율			
			%>
                <tr> 
                    <%if(i==1){%>
                    <td width="3%" rowspan="4" align="center" class='title'>청구</td>                    
                    <td width="3%" rowspan="3" align="center" class='title'>실행</td>
                    <%}%>                
                    <td <%if(i==0){%>colspan="3"<%}%> align="center" class='title'><%=fee.getGubun()%></td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("수금율")){%>                      
                      <%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(fee1.getTot_su1()))/AddUtil.parseFloat(String.valueOf(AddUtil.parseLong(fee1.getTot_su1())+AddUtil.parseLong(fee2.getTot_su1())))*100,2)%>%
                      <% }else{%>
                      <a href="javascript:list_move('1', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su1()%>건</a> 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("수금율")){%>                      
                      <%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(fee1.getTot_amt1()))/AddUtil.parseFloat(String.valueOf(AddUtil.parseLong(fee1.getTot_amt1())+AddUtil.parseLong(fee2.getTot_amt1())))*100,2)%>%                      
                      <%}else{%>
                      <%=AddUtil.parseDecimal2(fee.getTot_amt1())%>원 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("수금율")){%>
                      <%=fee.getTot_su2()%>% 
                      <% }else{%>
                      <a href="javascript:list_move('1', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su2()%>건</a> 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("수금율")){%>
                      <%=fee.getTot_amt2()%>% 
                      <%}else{%>
                      <%=AddUtil.parseDecimal2(fee.getTot_amt2())%>원 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("수금율")){%>
                      <%=fee.getTot_su3()%>% 
                      <% }else{%>
                      <a href="javascript:list_move('1', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su3()%>건</a> 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("수금율")){%>
                      <%=fee.getTot_amt3()%>% 
                      <%}else{%>
                      <%=AddUtil.parseDecimal2(fee.getTot_amt3())%>원 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("수금율")){%>
                      - 
                      <%}else{%>
                      <a href="javascript:list_move('1', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(fee.getTot_su2())+AddUtil.parseInt(fee.getTot_su3())%>건</a> 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(!fee.getGubun().equals("수금율")){%>
                      <%=AddUtil.parseDecimalLong(String.valueOf(AddUtil.parseLong(fee.getTot_amt2())+AddUtil.parseLong(fee.getTot_amt3())))%>원 
                      <%}else{%>
                      -&nbsp; 
                      <%}%>
                      </td>
                  </tr>
                  <%		}%>                  
                  <%	fee4 = (IncomingSBean)fees.elementAt(4);%>
                <tr> 
                    <td colspan="2" align="center" class='title'>예정</td>
                    <td align="right"><a href="javascript:list_move('1', '1', '<%=4+1%>');" onMouseOver="window.status=''; return true"><%=fee4.getTot_su1()%>건</a> </td>
                    <td align="right"><%=AddUtil.parseDecimal2(fee4.getTot_amt1())%>원 </td>
                    <td colspan="4" class='title'>&nbsp;</td>
                    <td align="right">-</td>
                    <td align="right">-</td>
                </tr>                       
                <tr> 
                    <td colspan="3" align="center" class='title'>계획대비수금율</td>
                    <td align="right"><%=fee3.getTot_su1()%>%</td>
                    <td align="right"><%=fee3.getTot_amt1()%>%</td>
                    <td align="right"><%=fee3.getTot_su2()%>%</td>
                    <td align="right"><%=fee3.getTot_amt2()%>%</td>
                    <td align="right"><%=fee3.getTot_su3()%>%</td>
                    <td align="right"><%=fee3.getTot_amt3()%>%</td>
                    <td align="right">-</td>
                    <td align="right">-</td>
                </tr>		                           
        	<%}else{%>
                  <tr> 
                    <td colspan="11" align="center">자료가 없습니다.</td>
                  </tr>
                  <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>    
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <%	//대여료 현황 - 연체율
        	Vector feedps = ac_db.getFeeStat_Dlyper(br_id, search_kd, brch_id, bus_id2);
        	int feedp_size = feedps.size();
        	if(feedp_size > 0){
        		for (int i = 0 ; i < feedp_size ; i++){
        			IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);%>		  
                <tr> 
                    <td width="16%" class='title'>받을대여료 총계</td>
                    <td width=21% align="right"><b><%=AddUtil.parseDecimalLong(feedp.getTot_amt1())%>원</b>&nbsp;</td>
                    <td width=21% class='title'>연체대여료</td>
                    <td width=21%" align="right"><b><font color='red'><%=AddUtil.parseDecimalLong(feedp.getTot_amt2())%>원</font></b>&nbsp;</td>
                    <td width=9% class='title'>연체율</td>
                    <td width=12%  align="center"><b><font color='red'><%=feedp.getTot_su1()%>%</font></b>&nbsp;</td>
                </tr>
        <%		}
        	}%>		  
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>    

    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>선수금 현황</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td colspan="2" width="16%"  rowspan="2" class='title'>구분</td>
                    <td colspan="2" width="21%"  class='title'>당월</td>
                    <td colspan="2" width="21%"  class='title'>당일</td>
                    <td colspan="2" width="21%"  class='title'>연체</td>
                    <td colspan="2" width="21%"  class='title'>합계(당일+연체)</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                </tr>
<%	//선수금 현황
	Vector pres = ac_db.getPreStat2(br_id, search_kd, brch_id, bus_id2);
	int pre_size = pres.size();
	if(pre_size > 0){//10 rows
		for (int i = 0 ; i < pre_size ; i++){
			IncomingSBean pre = (IncomingSBean)pres.elementAt(i);%>
                <tr> 
            <%	if(!pre.getGubun_sub().equals("N")){
					if(i%5 == 0){%>
                    <td align="center" class='title' rowspan="4"><%=pre.getGubun()%></td>
                    <td align="center" class='title'><%=pre.getGubun_sub()%></td>
                    <%		}else{%>
                    <td align="center" class='title'><%=pre.getGubun_sub()%></td>
                    <%		}
        			  	}else{%>
                    <td align="center" class='title' colspan="2"><%=pre.getGubun()%></td>
                    <%	}%>
                    <td align="right"  <%if(pre.getGubun().equals("소계")){%>class='is'<%}%>><%if(pre.getGubun().equals("수금율")){%><%=pre.getTot_su1()%>%<% }else{ if(pre.getGubun().equals("소계")){%><a href="javascript:list_move('2', '1', '<%=(i+1)/4%>');" onMouseOver="window.status=''; return true"><%=pre.getTot_su1()%>건</a><%}else{%><%=pre.getTot_su1()%>건<%}}%>&nbsp;</td>
                    <td align="right" <%if(pre.getGubun().equals("소계")){%>class='is'<%}%>><%if(pre.getGubun().equals("수금율")){%><%=pre.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(pre.getTot_amt1())%>원<%}%> &nbsp;</td>
                    <td align="right"  <%if(pre.getGubun().equals("소계")){%>class='is'<%}%>><%if(pre.getGubun().equals("수금율")){%><%=pre.getTot_su2()%>%<% }else{ if(pre.getGubun().equals("소계")){%><a href="javascript:list_move('2', '2', '<%=(i+1)/4%>');" onMouseOver="window.status=''; return true"><%=pre.getTot_su2()%>건</a><%}else{%><%=pre.getTot_su2()%>건<%}}%>&nbsp;</td>
                    <td align="right" <%if(pre.getGubun().equals("소계")){%>class='is'<%}%>><%if(pre.getGubun().equals("수금율")){%><%=pre.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(pre.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"  <%if(pre.getGubun().equals("소계")){%>class='is'<%}%>><%if(pre.getGubun().equals("수금율")){%><%=pre.getTot_su3()%>%<% }else{ if(pre.getGubun().equals("소계")){%><a href="javascript:list_move('2', '3', '<%=(i+1)/4%>');" onMouseOver="window.status=''; return true"><%=pre.getTot_su3()%>건</a><%}else{%><%=pre.getTot_su3()%>건<%}}%>&nbsp;</td>
                    <td align="right" <%if(pre.getGubun().equals("소계")){%>class='is'<%}%>><%if(pre.getGubun().equals("수금율")){%><%=pre.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(pre.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"  <%if(pre.getGubun().equals("소계")){%>class='is'<%}%>>
        			  <%if(!pre.getGubun().equals("수금율") && pre.getGubun().equals("소계")){%><a href="javascript:list_move('2', '6', '<%=(i+1)/4%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(pre.getTot_su2())+AddUtil.parseInt(pre.getTot_su3())%>건</a><%}else{%>-<%}%>&nbsp;
        			<td align="right" <%if(pre.getGubun().equals("소계")){%>class='is'<%}%>>
                      <%if(!pre.getGubun().equals("수금율")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(pre.getTot_amt2())+AddUtil.parseInt(pre.getTot_amt3())))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
<%		}
	}else{%>
                <tr> 
                    <td colspan="10" align="center">자료가 없습니다.</td>
                </tr>
<%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>    
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>월렌트/대차 대여료 수금현황</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td colspan="2" rowspan="2" width="16%" class='title'>구분</td>
                    <td colspan="2" width="21%" class='title'>당월</td>
                    <td colspan="2" width="21%" class='title'>당일</td>
                    <td colspan="2" width="21%" class='title'>연체</td>
                    <td colspan="2" width="21%" class='title'>합계(당일+연체)</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                </tr>
<%	//월렌트 현황
	Vector fees2 = ac_db.getFeeRmStat(br_id, search_kd, brch_id, bus_id2);
	int fee_size2 = fees2.size();
	if(fee_size2 > 0){
		for (int i = 0 ; i < fee_size2 ; i++){
			IncomingSBean fee = (IncomingSBean)fees2.elementAt(i);%>		
			
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>월렌트</td>
                    <%}%>
                    <td width="10%" align="center" class='title'><%=fee.getGubun()%></td>
                    <td align="right"><%if(fee.getGubun().equals("수금율")){%><%=fee.getTot_su1()%>%<% }else{%><a href="javascript:list_move('1', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su1()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("수금율")){%><%=fee.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(fee.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("수금율")){%><%=fee.getTot_su2()%>%<% }else{%><a href="javascript:list_move('1', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su2()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("수금율")){%><%=fee.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(fee.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("수금율")){%><%=fee.getTot_su3()%>%<% }else{%><a href="javascript:list_move('1', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su3()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("수금율")){%><%=fee.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(fee.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!fee.getGubun().equals("수금율")){%><a href="javascript:list_move('1', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(fee.getTot_su2())+AddUtil.parseInt(fee.getTot_su3())%>건</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(!fee.getGubun().equals("수금율")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(fee.getTot_amt2())+AddUtil.parseInt(fee.getTot_amt3())))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
        <%		}
        	}else{%>		
        		<tr>
        			<td colspan="10" align="center">자료가 없습니다.</td>
        		</tr>
<%	}%>	        
  
<%	//정비대차 현황
	Vector ins_sr2 = ac_db.getCarSRent2Stat(br_id, search_kd, brch_id, bus_id2);
	int ins_sr2_size = ins_sr2.size();
	if(ins_sr2_size > 0){
		for (int i = 0 ; i < ins_sr2_size ; i++){
			IncomingSBean ins_h = (IncomingSBean)ins_sr2.elementAt(i);%>		
			
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>정비대차</td>
                    <%}%>
                    <td width="10%" align="center" class='title'><%=ins_h.getGubun()%></td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_su1()%>%<% }else{%><a href="javascript:list_move('8', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su1()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_su2()%>%<% }else{%><a href="javascript:list_move('8', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su2()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_su3()%>%<% }else{%><a href="javascript:list_move('8', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su3()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!ins_h.getGubun().equals("수금율")){%><a href="javascript:list_move('8', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(ins_h.getTot_su2())+AddUtil.parseInt(ins_h.getTot_su3())%>건</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(!ins_h.getGubun().equals("수금율")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(ins_h.getTot_amt2())+AddUtil.parseInt(ins_h.getTot_amt3())))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
        <%		}
        	}else{%>		
        		<tr>
        			<td colspan="10" align="center">자료가 없습니다.</td>
        		</tr>
<%	}%>	
        
<%	//휴/대차료 현황
	Vector ins_hs = ac_db.getInsHStat(br_id, search_kd, brch_id, bus_id2);
	int ins_h_size = ins_hs.size();
	if(ins_h_size > 0){
		for (int i = 0 ; i < ins_h_size ; i++){
			IncomingSBean ins_h = (IncomingSBean)ins_hs.elementAt(i);%>		
			
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>대차료</td>
                    <%}%>
                    <td width="10%" align="center" class='title'><%=ins_h.getGubun()%></td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_su1()%>%<% }else{%><a href="javascript:list_move('5', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su1()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_su2()%>%<% }else{%><a href="javascript:list_move('5', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su2()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_su3()%>%<% }else{%><a href="javascript:list_move('5', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su3()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("수금율")){%><%=ins_h.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!ins_h.getGubun().equals("수금율")){%><a href="javascript:list_move('5', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(ins_h.getTot_su2())+AddUtil.parseInt(ins_h.getTot_su3())%>건</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(!ins_h.getGubun().equals("수금율")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(ins_h.getTot_amt2())+AddUtil.parseInt(ins_h.getTot_amt3())))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
        <%		}
        	}else{%>		
        		<tr>
        			<td colspan="10" align="center">자료가 없습니다.</td>
        		</tr>
<%	}%>	
            </table>
        </td>
    </tr>  
    <tr> 
        <td class=h></td>
    </tr>    
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타수금현황</span></td>
    </tr>             
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td colspan="2" rowspan="2" width="16%"  class='title'>구분</td>
                    <td colspan="2" width="21%"  class='title'>당월</td>
                    <td colspan="2" width="21%"  class='title'>당일</td>
                    <td colspan="2" width="21%"  class='title'>연체</td>
                    <td colspan="2" width="21%"  class='title'>합계(당일+연체)</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                </tr>
<%	//중도해지위약금 현황
	Vector clss = ac_db.getClsStat2(br_id, search_kd, brch_id, bus_id2);
	int cls_size = clss.size();
	if(cls_size > 0){
		for (int i = 0 ; i < cls_size ; i++){
			IncomingSBean cls = (IncomingSBean)clss.elementAt(i);%>		
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>해지정산</td>
                    <%}%>
                    <td width="10%" align="center" class='title'><%=cls.getGubun()%></td>
                    <td align="right"><%if(cls.getGubun().equals("수금율")){%><%=cls.getTot_su1()%>%<% }else{%><a href="javascript:list_move('6', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=cls.getTot_su1()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(cls.getGubun().equals("수금율")){%><%=cls.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(cls.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(cls.getGubun().equals("수금율")){%><%=cls.getTot_su2()%>%<% }else{%><a href="javascript:list_move('6', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=cls.getTot_su2()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(cls.getGubun().equals("수금율")){%><%=cls.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(cls.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(cls.getGubun().equals("수금율")){%><%=cls.getTot_su3()%>%<% }else{%><a href="javascript:list_move('6', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=cls.getTot_su3()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(cls.getGubun().equals("수금율")){%><%=cls.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(cls.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!cls.getGubun().equals("수금율")){%><a href="javascript:list_move('6', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(cls.getTot_su2())+AddUtil.parseInt(cls.getTot_su3())%>건</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(!cls.getGubun().equals("수금율")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(cls.getTot_amt2())+AddUtil.parseInt(cls.getTot_amt3())))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
        <%		}
        	}else{%>		
        		<tr>
        			<td colspan="9" align="center">자료가 없습니다.</td>
        		</tr>
<%	}%>	
                
<%	//과태료 현황
	Vector fines = ac_db.getFineStat(br_id, search_kd, brch_id, bus_id2);
	int fine_size = fines.size();
	if(fine_size > 0){
		for (int i = 0 ; i < fine_size ; i++){
			IncomingSBean fine = (IncomingSBean)fines.elementAt(i);%>		
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>과태료</td>
                    <%}%>
                    <td width="10%" align="center" class='title'><%=fine.getGubun()%></td>		
                    <td align="right"><%if(fine.getGubun().equals("수금율")){%><%=fine.getTot_su1()%>%<% }else{%><a href="javascript:list_move('3', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fine.getTot_su1()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getGubun().equals("수금율")){%><%=fine.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getGubun().equals("수금율")){%><%=fine.getTot_su2()%>%<% }else{%><a href="javascript:list_move('3', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fine.getTot_su2()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getGubun().equals("수금율")){%><%=fine.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getGubun().equals("수금율")){%><%=fine.getTot_su3()%>%<% }else{%><a href="javascript:list_move('3', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fine.getTot_su3()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getGubun().equals("수금율")){%><%=fine.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!fine.getGubun().equals("수금율")){%><a href="javascript:list_move('3', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(fine.getTot_su2())+AddUtil.parseInt(fine.getTot_su3())%>건</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                    <%if(!fine.getGubun().equals("수금율")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(fine.getTot_amt2())+AddUtil.parseInt(fine.getTot_amt3())))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
<%		}
	}else{%>		
		        <tr>
			        <td colspan="10" align="center">자료가 없습니다.</td>
		        </tr>
<%	}%>

<%	//면책금 현황
	Vector ins_ms = ac_db.getInsMStat(br_id, search_kd, brch_id, bus_id2);
	int ins_m_size = ins_ms.size();
	if(ins_m_size > 0){
		for (int i = 0 ; i < ins_m_size ; i++){
			IncomingSBean ins_m = (IncomingSBean)ins_ms.elementAt(i);%>		
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>면책금</td>
                    <%}%>
                    <td align="center" class='title'><%=ins_m.getGubun()%></td>
                    <td width="10%" align="right"><%if(ins_m.getGubun().equals("수금율")){%><%=ins_m.getTot_su1()%>%<% }else{%><a href="javascript:list_move('4', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_m.getTot_su1()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_m.getGubun().equals("수금율")){%><%=ins_m.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(ins_m.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_m.getGubun().equals("수금율")){%><%=ins_m.getTot_su2()%>%<% }else{%><a href="javascript:list_move('4', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_m.getTot_su2()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_m.getGubun().equals("수금율")){%><%=ins_m.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(ins_m.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_m.getGubun().equals("수금율")){%><%=ins_m.getTot_su3()%>%<% }else{%><a href="javascript:list_move('4', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_m.getTot_su3()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_m.getGubun().equals("수금율")){%><%=ins_m.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(ins_m.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!ins_m.getGubun().equals("수금율")){%><a href="javascript:list_move('4', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(ins_m.getTot_su2())+AddUtil.parseInt(ins_m.getTot_su3())%>건</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(!ins_m.getGubun().equals("수금율")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(ins_m.getTot_amt2())+AddUtil.parseInt(ins_m.getTot_amt3())))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
        <%		}
        	}else{%>		
        		<tr>
        			<td colspan="9" align="center">자료가 없습니다.</td>
        		</tr>
<%	}%>	
	
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
