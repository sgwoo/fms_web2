<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//일별통계
	function stat_search(mode, bus_id2){
		var fm = document.form1;	
		fm.mode.value = mode;
		fm.bus_id2.value = bus_id2;
		fm.action = 'stat_case_sh.jsp';
		fm.target='d_content';
		fm.submit();		
	}	

	//수금 스케줄 리스트 이동
	function list_move(bus_id2)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = '7';
		fm.gubun2.value = '2';
		fm.gubun3.value = '3';	
		fm.gubun4.value = '';					
		fm.s_kd.value = '8';		
		fm.t_wd.value = bus_id2;			
		url = "/acar/settle_acc/settle_s_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String dept_id = request.getParameter("dept_id")==null?"0001":request.getParameter("dept_id");	
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String tot_dly_amt = request.getParameter("tot_dly_amt")==null?"0":request.getParameter("tot_dly_amt");
	float dly_per1 = 0;
	float dly_per2 = 0;
	String per2 = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='search_kd' value='<%=search_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='dept_id' value='<%=dept_id%>'>
<input type='hidden' name='bus_id2' value='<%=bus_id2%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='tot_dly_amt' value='<%=tot_dly_amt%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td class="line">              
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <%//연체율 리스트
			Vector feedps = st_db.getStatSettleList7(brch_id, dept_id, save_dt, "");
			int feedp_size = feedps.size();%>
			<input type='hidden' name='size' value='<%=feedp_size%>'>
<%			if(feedp_size > 0){
				for (int i = 0 ; i < feedp_size ; i++){
					IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);
					if(feedp.getTot_su4().equals("")){
						dly_per2 = Float.parseFloat(feedp.getTot_amt2())/Float.parseFloat(tot_dly_amt)*100;
						per2 = (dly_per2==0)?"0.0":Float.toString(dly_per2).substring(0,Float.toString(dly_per2).indexOf(".")+3);
					}else{
						per2 = feedp.getTot_su4();
					}
		  %>
                <tr> 
                    <td align="center" width="5%"><%=i+1%></td>
                    <td align="center" width="8%"><%=c_db.getNameById(feedp.getBr_id(), "BRCH")%></td>
                    <td align="center" width="8%"><%if(feedp.getGubun().equals("000003")){%>총무팀<%}else{%><%=c_db.getNameById(feedp.getDept_id(), "DEPT")%><%}%></td>
                    <td align="center" width="7%"><a href="javascript:list_move('<%=feedp.getGubun()%>');" onMouseOver="window.status=''; return true"><%=c_db.getNameById(feedp.getGubun(), "USER")%></a>
                      <input type="hidden" name="bus_id" value="<%=feedp.getGubun()%>">
                    </td>
                    <td align="center" width="7%"><a href="javascript:list_move('<%=feedp.getGubun()%>');" onMouseOver="window.status=''; return true">
                      <% 	/*if(feedp.getGubun().equals("000010"))		out.print("이점미");	//강주원
        					else if(feedp.getGubun().equals("000011"))	out.print("진병갑");	//김욱
        					else if(feedp.getGubun().equals("000012"))	out.print("정현미");	//이광희
        					else if(feedp.getGubun().equals("000013"))	out.print("권용순");	//황수연
        					else if(feedp.getGubun().equals("000020"))	out.print("김태우");	//오성호
        					else if(feedp.getGubun().equals("000023"))	out.print("백미경");	//송민재
        					else if(feedp.getGubun().equals("000025"))	out.print("서유영");	//김헌태
        					else if(feedp.getGubun().equals("000026"))	out.print("임은집");	//김광수
        					else if(feedp.getGubun().equals("000034"))	out.print("이의상");	//최준원*/
        /*					if(feedp.getGubun().equals("000010"))		out.print("이의상");	//강주원
        					else if(feedp.getGubun().equals("000011"))	out.print("서유영");	//김욱
        					else if(feedp.getGubun().equals("000012"))	out.print("진병갑");	//이광희
        					else if(feedp.getGubun().equals("000013"))	out.print("정현미");	//황수연
        					else if(feedp.getGubun().equals("000020"))	out.print("백미경");	//오성호
        					else if(feedp.getGubun().equals("000023"))	out.print("이점미");	//송민재
        					else if(feedp.getGubun().equals("000025"))	out.print("김태우");	//김헌태
        					else if(feedp.getGubun().equals("000026"))	out.print("권용순");	//김광수
        					else if(feedp.getGubun().equals("000034"))	out.print("김경선");	//최준원 
        					if(feedp.getGubun().equals("000010"))		out.print("김태우");	//강주원
        					else if(feedp.getGubun().equals("000011"))	out.print("고연미");	//김욱
        					else if(feedp.getGubun().equals("000012"))	out.print("이의상");	//이광희
        					else if(feedp.getGubun().equals("000013"))	out.print("김경선");	//황수연
        					else if(feedp.getGubun().equals("000020"))	out.print("서유영");	//오성호
        					else if(feedp.getGubun().equals("000023"))	out.print("정현미");	//송민재
        					else if(feedp.getGubun().equals("000025"))	out.print("백미경");	//김헌태
        					else if(feedp.getGubun().equals("000026"))	out.print("이점미");	//김광수
        					else if(feedp.getGubun().equals("000034"))	out.print("진병갑");	//최준원 */
        					//2007년상반기
        					/*if(feedp.getGubun().equals("000010"))		out.print("백미경");	//강주원
        					else if(feedp.getGubun().equals("000011"))	out.print("김욱");		//김욱
        					else if(feedp.getGubun().equals("000012"))	out.print("서유영");	//이광희
        					else if(feedp.getGubun().equals("000013"))	out.print("고연미");	//황수연
        					else if(feedp.getGubun().equals("000020"))	out.print("이점미");	//오성호
        					else if(feedp.getGubun().equals("000023"))	out.print("차영화");	//송민재
        					else if(feedp.getGubun().equals("000025"))	out.print("정현미");	//김헌태
        					else if(feedp.getGubun().equals("000026"))	out.print("김경선");	//김광수
        					else if(feedp.getGubun().equals("000034"))	out.print("김태우");	//최준원
        					//2007년하반기
        					if(feedp.getGubun().equals("000010"))		out.print("정현미");	//강주원
        					else if(feedp.getGubun().equals("000011"))	out.print("이점미");	//김욱
        					else if(feedp.getGubun().equals("000012"))	out.print("");			//이광희
        					else if(feedp.getGubun().equals("000013"))	out.print("백미경");	//황수연
        					else if(feedp.getGubun().equals("000020"))	out.print("김경선");	//오성호
        					else if(feedp.getGubun().equals("000023"))	out.print("김태우");	//송민재
        					else if(feedp.getGubun().equals("000025"))	out.print("고연미");	//김헌태
        					else if(feedp.getGubun().equals("000026"))	out.print("차영화");	//김광수
        					else if(feedp.getGubun().equals("000034"))	out.print("");			//최준원 */
        					//2008년상반기
        					if(feedp.getGubun().equals("000010"))		out.print("김태연");	//강주원
        					else if(feedp.getGubun().equals("000011"))	out.print("김태우");	//김욱
        					else if(feedp.getGubun().equals("000013"))	out.print("신입");		//황수연
        					else if(feedp.getGubun().equals("000020"))	out.print("권용식");	//오성호
        					else if(feedp.getGubun().equals("000023"))	out.print("배현숙");	//송민재
        					else if(feedp.getGubun().equals("000025"))	out.print("이점미");	//김헌태
        					else if(feedp.getGubun().equals("000026"))	out.print("정현미");	//김광수
        					else if(feedp.getGubun().equals("000079"))	out.print("차영화");    //김우석
        					else if(feedp.getGubun().equals("000083"))	out.print("고연미");	//강명길
        					else if(feedp.getGubun().equals("000091"))	out.print("이의상");	//정경수
        					else if(feedp.getGubun().equals("000090"))	out.print("백미경");	//이정환
        					else if(feedp.getGubun().equals("000066"))	out.print("최은아");	//정준형
        					else if(feedp.getGubun().equals("000088"))	out.print("최은아");	//조원규
        					
        					//if(feedp.getBr_id().equals("B1"))			out.print("최은아");
        					if(feedp.getBr_id().equals("D1"))			out.print("박연실");
        					%>
        					</a>
                    </td>
                    <td align="center" width="13%"> 
                      <input type="text" name="tot_amt" value="<%=Util.parseDecimalLong(feedp.getTot_amt1())%>" size="11" class="whitenum">
                      원</td>
                    <td align="center" width="8%"> 
                      <input type="text" name="su" value="<%=Util.parseDecimal(feedp.getTot_su2())%>" size="4" class="whitenum">
                      건</td>
                    <td align="center" width="12%"> 
                      <input type="text" name="amt" value="<%=Util.parseDecimal(feedp.getTot_amt2())%>" size="10" class="whitenum">
                      원</td>
                    <td align="center" width="9%"> 
                      <input type="text" name="per1" value="<%=AddUtil.parseFloatCipher(feedp.getTot_su3(),2)%>" size="5" class="whitenum">
                      %</td>
                    <td align="center" width="9%"> 
                      <input type="text" name="per2" value="<%=AddUtil.parseFloatCipher(per2,2)%>" size="4" class="whitenum">
                      %</td>
                    <td align="center" width="7%"> 
                      <a href="javascript:stat_search('d', '<%=feedp.getGubun()%>');" name="stat_dg"><img src=../images/center/button_in_day.gif align=absmiddle border=0>
                    </td>
                    <td align="center" width="7%"> 
                      <a href="javascript:stat_search('m', '<%=feedp.getGubun()%>');" name="stat_mg"><img src=../images/center/button_in_month.gif align=absmiddle border=0>
                    </td>
                </tr>
          <%	}
			}else{%>
                <tr> 
                    <td align="center" colspan="12">등록된 자료가 없습니다.</td>
                </tr>
          <%}%>
            </table>
		</td>
    </tr>
</table>
</form>  
</body>
</html>
