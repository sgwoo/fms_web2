<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		fm.submit();	
	}

	//디스플레이 타입
	function cng_input(){
		var fm = document.form1;
		/*
		if(fm.search_kd.options[fm.search_kd.selectedIndex].value == '1'){
			td_brch_id.style.display = '';
			td_bus_id2.style.display = 'none';
		}else if(fm.search_kd.options[fm.search_kd.selectedIndex].value == '2'){
			td_brch_id.style.display = 'none';
			td_bus_id2.style.display = '';
		}else{
			td_brch_id.style.display = 'none';
			td_bus_id2.style.display = 'none';
		}
		*/
	}
	
	//지출 스케줄 리스트 이동
	function list_move(gubun1, gubun2, gubun3)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = gubun1;
		fm.gubun2.value = gubun2;
		fm.gubun3.value = gubun3;	
		/*
		if(fm.search_kd.options[fm.search_kd.selectedIndex].value == '1'){		//영업소				
			fm.s_kd.value = '6';		
			fm.t_wd.value = fm.brch_id.options[fm.brch_id.selectedIndex].value;
		}else if(fm.search_kd.options[fm.search_kd.selectedIndex].value == '2'){	//영업담당자			
			fm.s_kd.value = '8';		
			fm.t_wd.value = fm.bus_id2.options[fm.bus_id2.selectedIndex].value;			
		}else{
			fm.s_kd.value = '0';		
			fm.t_wd.value = '';					
		}
		*/
		var idx = gubun1;
		if(idx == '8') url = "/acar/con_debt/debt_frame_s.jsp";
		else if(idx == '9') url = "/acar/con_ins/ins_frame_s.jsp?f_list=now";
		else if(idx == '10'){
			fm.gubun4.value = '5';
			url = "/acar/forfeit_mng/forfeit_s_frame.jsp";
		}
		else if(idx == '11') url = "/acar/commi_mng/commi_frame_s.jsp";
		else if(idx == '12') url = "/acar/mng_exp/exp_frame_s.jsp";	
		else if(idx == '13') url = "/acar/con_tax/tax_frame_s.jsp";					
		else if(idx == '14'){
			fm.gubun4.value = '1';		
			url = "/acar/con_ser/service_frame_s.jsp";							
		}
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
//-->
</script>
</head>

<body leftmargin=15>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	Vector users = c_db.getUserList("", "", "EMP"); //영업담당자 리스트
	int user_size = users.size();	

	//임원이거나 총무팀직원은 전체검색 / 사원이고 총무팀가 아닌 직원은 영업소담당자로 조회
	String id_chk = c_db.getUserBusYn(user_id);
	if(!id_chk.equals("") && search_kd.equals("") && bus_id2.equals("")){
		search_kd="2";
		bus_id2=user_id;
	}
	
%>
<form name='form1' method='post' action='incoming.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value=''>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 영업비용관리 > <span class=style5>지출현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<!--
    <tr> 
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td width=140>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_search.gif align=absmiddle>&nbsp;
                      <select name='search_kd' onChange='javascript:cng_input()'>
                        <option value='0' <%if(search_kd.equals("0")){%>selected<%}%>>전체 </option>
        				<%//if(br_id.equals("S1")){%>
                        <option value='1' <%if(search_kd.equals("1")){%>selected<%}%>>영업소 </option>
        				<%//}%>
                        <option value='2' <%if(search_kd.equals("2")){%>selected<%}%>>담당자 </option>
                      </select>
                    </td>
                    <td id="td_brch_id"  <%if(!search_kd.equals("1")){%> style='display:none'<%}%> width="100"> 
                      <select name='brch_id'>
                        <%	if(brch_size > 0){// && br_id.equals("S1")
        							for (int i = 0 ; i < brch_size ; i++){
        								Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID"))) || br_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
                        <%= branch.get("BR_NM")%> </option>
                        <%			}
        					}		%>
                      </select>
                    </td>
                    <td id="td_bus_id2"  <%if(!search_kd.equals("2")){%> style='display:none'<%}%> width="100"> 
                      <select name='bus_id2'>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(bus_id2.equals(user.get("USER_ID"))  || user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>                                                       						
                      </select>
                    </td>
                    <td><a href='javascript:search()'><img src=../images/center/button_search.gif align=absmiddle border=0></a></td>
                </tr>
            </table>
        </td>
    </tr>
	-->
    <tr> 
        <td align="right"></td>
    </tr> 
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>할부금 상환 현황</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr> 
    <tr> 
        <td class='line' > 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
              <tr> 
                <td rowspan="2" width="16%" class='title' align="center">구분</td>
                <td colspan="2" width="21%" class='title' align="center">당월</td>
                <td colspan="2" width="21%" class='title' align="center">당일</td>
                <td colspan="2" width="21%" class='title' align="center">연체</td>
                <td colspan="2" width="21%" class='title' align="center">합계</td>
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
    <%	//할부금 현황
    	Vector debts = ac_db.getDebtStat(br_id, search_kd, brch_id, bus_id2);
    	int debt_size = debts.size();
    	if(debt_size > 0){
    		for (int i = 0 ; i < debt_size ; i++){
    			IncomingSBean debt = (IncomingSBean)debts.elementAt(i);%>		
            <tr> 
                <td align="center" class='title'><%=debt.getGubun()%></td>
                <td align="right"><%if(debt.getSt()==1){%><%=debt.getTot_su1()%>%<% }else{%><a href="javascript:list_move('8', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=debt.getTot_su1()%>건</a><%}%>&nbsp;</td>
                <td align="right"><%if(debt.getSt()==1){%><%=debt.getTot_amt1()%>%<%}else{%><%=Util.parseDecimalLong(debt.getTot_amt1())%>원<%}%>&nbsp;</td>
                <td align="right"><%if(debt.getSt()==1){%><%=debt.getTot_su2()%>%<% }else{%><a href="javascript:list_move('8', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=debt.getTot_su2()%>건</a><%}%>&nbsp;</td>
                <td align="right"><%if(debt.getSt()==1){%><%=debt.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(debt.getTot_amt2())%>원<%}%>&nbsp;</td>
                <td align="right"><%if(debt.getSt()==1){%><%=debt.getTot_su3()%>%<% }else{%><a href="javascript:list_move('8', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=debt.getTot_su3()%>건</a><%}%>&nbsp;</td>
                <td align="right"><%if(debt.getSt()==1){%><%=debt.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(debt.getTot_amt3())%>원<%}%>&nbsp;</td>
                <td align="right">
                  <%if(debt.getSt()==1){%>-<%}else{%><a href="javascript:list_move('8', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=Integer.parseInt(debt.getTot_su2())+Integer.parseInt(debt.getTot_su3())%>건</a><%}%>&nbsp;</td> 
    			<td align="right">
                  <%if(debt.getSt()==0){%><%=Util.parseDecimal(Util.parseInt(debt.getTot_amt2())+Util.parseInt(debt.getTot_amt3()))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
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
    <tr> 
        <td></td>
    </tr>  
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험료 납부 현황</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr> 
    <tr> 
        <td class='line' > 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" width="16%" class='title' align="center">구분</td>
                    <td colspan="2" width="21%" class='title' align="center">당월</td>
                    <td colspan="2" width="21%" class='title' align="center">당일</td>
                    <td colspan="2" width="21%" class='title' align="center">연체</td>
                    <td colspan="2" width="21%" class='title' align="center">합계</td>
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
<%	//보험금 현황
	Vector inss = ac_db.getInsStat(br_id, search_kd, brch_id, bus_id2, "");
	int ins_size = inss.size();
	if(ins_size > 0){//10 rows
		for (int i = 0 ; i < ins_size ; i++){
			IncomingSBean ins = (IncomingSBean)inss.elementAt(i);%>
                <tr> 
                    <td align="center" class='title'><%=ins.getGubun()%></td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_su1()%>%<% }else{%><a href="javascript:list_move('9', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins.getTot_su1()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(ins.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_su2()%>%<% }else{%><a href="javascript:list_move('9', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins.getTot_su2()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(ins.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_su3()%>%<% }else{%><a href="javascript:list_move('9', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins.getTot_su3()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(ins.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right">
                      <%if(ins.getSt()==1){%>-<%}else{%><a href="javascript:list_move('9', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=Integer.parseInt(ins.getTot_su2())+Integer.parseInt(ins.getTot_su3())%>건</a><%}%>&nbsp;</td>
        			<td align="right">
                      <%if(ins.getSt()==0){%><%=Util.parseDecimal(Util.parseInt(ins.getTot_amt2())+Util.parseInt(ins.getTot_amt3()))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
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
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>과태료 납부 현황</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr> 
    <tr> 
        <td class='line' > 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td rowspan="2" width="16%" class='title'>구분</td>
                    <td colspan="2" width="21%" class='title'>당월</td>
                    <td colspan="2" width="21%" class='title'>당일</td>
                    <td colspan="2" width="21%" class='title'>연체</td>
                    <td colspan="2" width="21%" class='title'>합계</td>
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
    <%	//과태료 현황
    	Vector fines = ac_db.getFineExpStat(br_id, search_kd, brch_id, bus_id2);
    	int fine_size = fines.size();
    	if(fine_size > 0){
    		for (int i = 0 ; i < fine_size ; i++){
    			IncomingSBean fine = (IncomingSBean)fines.elementAt(i);%>		
                <tr> 
                    <td align="center" class='title'><%=fine.getGubun()%></td>		
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_su1()%>%<% }else{%><a href="javascript:list_move('10', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fine.getTot_su1()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_su2()%>%<% }else{%><a href="javascript:list_move('10', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fine.getTot_su2()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_su3()%>%<% }else{%><a href="javascript:list_move('10', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fine.getTot_su3()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(fine.getSt()==1){%>-<%}else{%><a href="javascript:list_move('10', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=Integer.parseInt(fine.getTot_su2())+Integer.parseInt(fine.getTot_su3())%>건</a><%}%>&nbsp;</td>
        			<td align="right">
                      <%if(fine.getSt()==0){%><%=Util.parseDecimal(Util.parseInt(fine.getTot_amt2())+Util.parseInt(fine.getTot_amt3()))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
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
        <td></td>
    </tr>
  <!--
  <tr> 
    <td colspan="2">4. 정비비 지출 현황</td>
  </tr>
  <tr> 
    <td width="20" height="20">&nbsp;</td>
    <td width="763"  class='line' > 
        <table width="780" border="0" cellspacing="1" cellpadding="0">
          <tr align="center"> 
          <td rowspan="2" class='title'>구분</td>
          <td colspan="2" class='title'>당월</td>
          <td colspan="2" class='title'>당일</td>
          <td colspan="2" class='title'>연체</td>
          <td colspan="2" class='title'>합계</td>
        </tr>
        <tr align="center"> 
            <td width="60" class='title'>건수</td>
          <td width="100" class='title'>금액</td>
            <td width="60" class='title'>건수</td>
          <td width="100" class='title'>금액</td>
            <td width="60" class='title'>건수</td>
          <td width="100" class='title'>금액</td>
            <td width="60" class='title'>건수</td>
          <td class='title'>금액</td>
        </tr>-->
<%	//정비비 현황
//	Vector sers = ac_db.getServiceStat(br_id, search_kd, brch_id, bus_id2);
//	int ser_size = sers.size();
//	if(ser_size > 0){
//		for (int i = 0 ; i < ser_size ; i++){
//			IncomingSBean ser = (IncomingSBean)sers.elementAt(i);%>		
<!--        <tr> 
            <td width="120" align="center" class='title'><%//=ser.getGubun()%></td>		
            <td width="60"  align="right"><%//if(ser.getSt()==1){%><%//=ser.getTot_su1()%>%<% //}else{%><a href="javascript:list_move('14', '1', '<%//=i+1%>');" onMouseOver="window.status=''; return true"><%//=ser.getTot_su1()%>건</a><%//}%>&nbsp;</td>
            <td width="100" align="right"><%//if(ser.getSt()==1){%><%//=ser.getTot_amt1()%>%<%//}else{%><%//=Util.parseDecimal(ser.getTot_amt1())%>원<%//}%>&nbsp;</td>
            <td width="60"  align="right"><%//if(ser.getSt()==1){%><%//=ser.getTot_su2()%>%<% //}else{%><a href="javascript:list_move('14', '2', '<%//=i+1%>');" onMouseOver="window.status=''; return true"><%//=ser.getTot_su2()%>건</a><%//}%>&nbsp;</td>
            <td width="100" align="right"><%//if(ser.getSt()==1){%><%//=ser.getTot_amt2()%>%<%//}else{%><%//=Util.parseDecimal(ser.getTot_amt2())%>원<%//}%>&nbsp;</td>
            <td width="60"  align="right"><%//if(ser.getSt()==1){%><%//=ser.getTot_su3()%>%<% //}else{%><a href="javascript:list_move('14', '3', '<%//=i+1%>');" onMouseOver="window.status=''; return true"><%//=ser.getTot_su3()%>건</a><%//}%>&nbsp;</td>
            <td width="100" align="right"><%//if(ser.getSt()==1){%><%//=ser.getTot_amt3()%>%<%//}else{%><%//=Util.parseDecimal(ser.getTot_amt3())%>원<%//}%>&nbsp;</td>
            <td width="60"  align="right"> 
              <%//if(ser.getSt()==1){%>-<%//}else{%><a href="javascript:list_move('14', '6', '<%//=i+1%>');" onMouseOver="window.status=''; return true"><%//=Integer.parseInt(ser.getTot_su2())+Integer.parseInt(ser.getTot_su3())%>건</a><%//}%>&nbsp;</td>			
			<td align="right">
              <%//if(ser.getSt()==0){%><%//=Util.parseDecimal(Util.parseInt(ser.getTot_amt2())+Util.parseInt(ser.getTot_amt3()))%>원<%//}else{%>-&nbsp;<%//}%>&nbsp;</td>
        </tr>-->
<%//		}
//	}else{%>		
<!--		<tr>
			<td colspan="10" align="center">자료가 없습니다.</td>
		</tr>-->
<%//	}%>	
<!--      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2"></td>
  </tr>-->  
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업수당 지급 현황</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr> 
    <tr> 
        <td class='line' > 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td rowspan="2" width="16%" class='title'>구분</td>
                    <td colspan="2" width="21%" class='title'>당월</td>
                    <td colspan="2" width="21%" class='title'>당일</td>
                    <td colspan="2" width="21%" class='title'>연체</td>
                    <td colspan="2" width="21%" class='title'>합계</td>
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
<%	//지급수수료 현황
	Vector commis = ac_db.getCommiStat(br_id, search_kd, brch_id, bus_id2);
	int commi_size = commis.size();
	if(commi_size > 0){
		for (int i = 0 ; i < commi_size ; i++){
			IncomingSBean commi = (IncomingSBean)commis.elementAt(i);%>		
                <tr> 
                    <td align="center" class='title'><%=commi.getGubun()%></td>
                    <td align="right"><%if(commi.getSt()==1){%><%=commi.getTot_su1()%>%<% }else{%><a href="javascript:list_move('11', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=commi.getTot_su1()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(commi.getSt()==1){%><%=commi.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(commi.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(commi.getSt()==1){%><%=commi.getTot_su2()%>%<% }else{%><a href="javascript:list_move('11', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=commi.getTot_su2()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(commi.getSt()==1){%><%=commi.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(commi.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(commi.getSt()==1){%><%=commi.getTot_su3()%>%<% }else{%><a href="javascript:list_move('11', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=commi.getTot_su3()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(commi.getSt()==1){%><%=commi.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(commi.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(commi.getSt()==1){%>-<%}else{%><a href="javascript:list_move('11', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=Integer.parseInt(commi.getTot_su2())+Integer.parseInt(commi.getTot_su3())%>건</a><%}%>&nbsp;</td>
        			<td align="right">
                      <%if(commi.getSt()==0){%><%=Util.parseDecimal(Util.parseInt(commi.getTot_amt2())+Util.parseInt(commi.getTot_amt3()))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
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
    <tr> 
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타비용 지출 현황</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr> 
    <tr> 
        <td class='line' > 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td rowspan="2" width="16%" class='title'>구분</td>
                    <td colspan="2" width="21%" class='title'>당월</td>
                    <td colspan="2" width="21%" class='title'>당일</td>
                    <td colspan="2" width="21%" class='title'>연체</td>
                    <td colspan="2" width="21%" class='title'>합계</td>
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
<%	//매출배용 현황
	Vector exps = ac_db.getExpStat(br_id, search_kd, brch_id, bus_id2);
	int exp_size = exps.size();
	if(exp_size > 0){
		for (int i = 0 ; i < exp_size ; i++){
			IncomingSBean exp = (IncomingSBean)exps.elementAt(i);%>		
                <tr> 
                    <td align="center" class='title'><%=exp.getGubun()%></td>
                    <td align="right"><%if(exp.getSt()==1){%><%=exp.getTot_su1()%>%<% }else{%><a href="javascript:list_move('12', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=exp.getTot_su1()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(exp.getSt()==1){%><%=exp.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(exp.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(exp.getSt()==1){%><%=exp.getTot_su2()%>%<% }else{%><a href="javascript:list_move('12', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=exp.getTot_su2()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(exp.getSt()==1){%><%=exp.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(exp.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(exp.getSt()==1){%><%=exp.getTot_su3()%>%<% }else{%><a href="javascript:list_move('12', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=exp.getTot_su3()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(exp.getSt()==1){%><%=exp.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(exp.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(exp.getSt()==1){%>-<%}else{%><a href="javascript:list_move('12', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=Integer.parseInt(exp.getTot_su2())+Integer.parseInt(exp.getTot_su3())%>건</a><%}%>&nbsp;</td>
        			<td align="right">
                      <%if(exp.getSt()==0){%><%=Util.parseDecimal(Util.parseInt(exp.getTot_amt2())+Util.parseInt(exp.getTot_amt3()))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
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
    <tr> 
        <td></td>
    </tr>  
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>특소세 납부 현황</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr> 
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td rowspan="2" width="16%" class='title'>구분</td>
                    <td colspan="2" width="21%" class='title'>당월</td>
                    <td colspan="2" width="21%" class='title'>당일</td>
                    <td colspan="2" width="21%" class='title'>연체</td>
                    <td colspan="2" width="21%" class='title'>합계</td>
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
<%	//특소세 현황
	Vector taxs = ac_db.getTaxStat(br_id, search_kd, brch_id, bus_id2);
	int tax_size = taxs.size();
	if(tax_size > 0){
		for (int i = 0 ; i < tax_size ; i++){
			IncomingSBean tax = (IncomingSBean)taxs.elementAt(i);%>		
                <tr> 
                    <td align="center" class='title'><%=tax.getGubun()%></td>
                    <td align="right"><%if(tax.getSt()==1){%><%=tax.getTot_su1()%>%<% }else{%><a href="javascript:list_move('13', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=tax.getTot_su1()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(tax.getSt()==1){%><%=tax.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(tax.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(tax.getSt()==1){%><%=tax.getTot_su2()%>%<% }else{%><a href="javascript:list_move('13', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=tax.getTot_su2()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(tax.getSt()==1){%><%=tax.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(tax.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(tax.getSt()==1){%><%=tax.getTot_su3()%>%<% }else{%><a href="javascript:list_move('13', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=tax.getTot_su3()%>건</a><%}%>&nbsp;</td>
                    <td align="right"><%if(tax.getSt()==1){%><%=tax.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(tax.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(tax.getSt()==1){%>-<%}else{%><a href="javascript:list_move('13', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=Integer.parseInt(tax.getTot_su2())+Integer.parseInt(tax.getTot_su3())%>건</a><%}%>&nbsp;</td>
        			<td align="right">
                      <%if(tax.getSt()==0){%><%=Util.parseDecimal(Util.parseInt(tax.getTot_amt2())+Util.parseInt(tax.getTot_amt3()))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
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
    <tr> 
        <td></td>
    </tr>   
</table>
</form>
</body>
</html>
