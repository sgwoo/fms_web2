<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//기간비용
	function view_cons_acar(user_id){
		window.open('/fms2/consignment/cons_sms_today.jsp?user_id='+user_id, "CONS_SMS", "left=0, top=0, width=400, height=300, scrollbars=yes, status=yes, resize");
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//사원별 탁송요청 현황
	Vector scds3 = cs_db.getConsReqUserStat2(brch_id, gubun1, st_dt, end_dt, sort);
	int scd_size3 = scds3.size();
	
	String standby_dt1 = AddUtil.getDate(4);
	String standby_dt2 = af_db.getValidDt(rs_db.addDay(standby_dt1, 1));
	
	//사원별 탁송요청 현황
	Vector scds4 = cs_db.getConsStandbyUserList(brch_id, standby_dt1, standby_dt2);
	int scd_size4 = scds4.size();
	
	int sum0 = 0;
	int sum1 = 0;
	int sum2 = 0;
	int sum3 = 0;
	int sum4 = 0;
	int sum5 = 0;
	int sum6 = 0;
	int sum7 = 0;
	int sum8 = 0;
	int sum9 = 0;
	int sum10 = 0;
	int sum11 = 0;
	int sum12 = 0;
	
	long sum21 = 0;
	long sum22 = 0;
	long sum23 = 0;
	
%>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='car_comp_id' value=''>
<input type='hidden' name='tot_su' value=''>
<input type='hidden' name='go_url' value='../ins_stat/ins_s4_frame.jsp'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width="5%" rowspan="3" class='title'>순위</td>
                    <td width="10%" rowspan="3" class='title'>부서</td>
                    <td width="10%" rowspan="3" class='title'>성명</td>
                    <td colspan="3" class='title'>탁송수행</td>
                    <td width="6%" rowspan="3" class='title'>탁송대기</td>						
                    <td colspan="7" class='title'>탁송요청</td>
                </tr>
                <tr>
                    <td width="6%" rowspan="2" class='title'>본인건수</td>
                    <td width="6%" rowspan="2" class='title'>지원건수</td>
                    <td width="6%" rowspan="2" class='title'>소계건수</td>
                    <td colspan="4" class='title'>자체탁송</td>
                    <td width="7%" rowspan="2" class='title'>코리아탁송</td>
                    <td width="7%" rowspan="2" class='title'>전국탁송</td>
                    <td width="7%" rowspan="2" class='title'>합계</td>
                </tr>
                <tr>
                  <td width="6%" class='title'>건수</td>
                  <td width="8%" class='title'>의뢰</td>
                  <td width="8%" class='title'>수행</td>
                  <td width="8%" class='title'>비용</td>
                </tr>
              <%	for(int i = 0 ; i < scd_size3 ; i++){
    					Hashtable ht = (Hashtable)scds3.elementAt(i);%>		  
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("NM")%></td>
                    <td align="center"><%=ht.get("USER_NM")%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT1")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT2")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT3")))%>건&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT7")))%>건&nbsp;&nbsp;</td>			
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT4")))%>건&nbsp;</td>			
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT8")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT3")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT9")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT5")))%>건&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT6")))%>건&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT0")))%>건&nbsp;</td>
                </tr>
    <%			sum0 = sum0 + Util.parseInt(String.valueOf(ht.get("CNT0")));
    			sum1 = sum1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
    			sum2 = sum2 + Util.parseInt(String.valueOf(ht.get("CNT2")));
    			sum3 = sum3 + Util.parseInt(String.valueOf(ht.get("CNT3")));
    			sum4 = sum4 + Util.parseInt(String.valueOf(ht.get("CNT4")));
    			sum5 = sum5 + Util.parseInt(String.valueOf(ht.get("CNT5")));
    			sum6 = sum6 + Util.parseInt(String.valueOf(ht.get("CNT6")));
    			sum7 = sum7 + Util.parseInt(String.valueOf(ht.get("CNT7")));
    //			sum8 = sum8 + Util.parseInt(String.valueOf(ht.get("CNT8")));
    //			sum9 = sum9 + Util.parseInt(String.valueOf(ht.get("CNT9")));
	
    			sum21 = sum21 + Util.parseLong(String.valueOf(ht.get("AMT8")));
    			sum22 = sum22 + Util.parseLong(String.valueOf(ht.get("AMT3")));
				sum23 = sum23 + Util.parseLong(String.valueOf(ht.get("AMT9")));
    				}%>			  
                <tr> 
                    <td colspan="3" align="center" class=title>합계</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(sum1)%>건&nbsp;</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(sum2)%>건&nbsp;</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(sum3)%>건&nbsp;</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(sum7)%>건&nbsp;</td>			
                    <td class=title style='text-align:right'><%=Util.parseDecimal(sum4)%>건&nbsp;</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(sum21)%>원</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(sum22)%>원</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(sum23)%>원</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(sum5)%>건&nbsp;</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(sum6)%>건&nbsp;</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(sum0)%>건&nbsp;</td>			
                </tr>
            </table>
        </td>
    </tr>
<%	sum1 = 0;
	sum2 = 0;
	sum3 = 0;
	sum4 = 0;
	sum5 = 0;
	sum6 = 0;
	sum7 = 0;
	sum8 = 0;
	sum9 = 0;
	sum10 = 0;
	sum11 = 0;
	sum12 = 0;
%>		
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td style='background-color:e5e5e5; height:1'></td>
	</tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width="5%" rowspan="2" class='title'>순위</td>
                    <td width="10%" rowspan="2" class='title'>부서</td>
                    <td width="10%" rowspan="2" class='title'>성명</td>
                    <td colspan="4" class='title'><%=AddUtil.ChangeDate2(standby_dt1)%></td>
                    <td colspan="4" class='title'><%=AddUtil.ChangeDate2(standby_dt2)%></td>
                </tr>
                <tr>
                    <td width="9%" class='title'>FULL</td>
                    <td width="9%" class='title'>오전</td>
                    <td width="10%" class='title'>오후</td>
                    <td width="10%" class='title'>없음</td>
                    <td class='title'>FULL</td>
                    <td class='title'>오전</td>
                    <td class='title'>오후</td>
                    <td class='title'>없음</td>
                </tr>
              <%	for(int i = 0 ; i < scd_size4 ; i++){
    					Hashtable ht = (Hashtable)scds4.elementAt(i);%>		  
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("NM")%></td>
                    <td align="center"><%if(user_id.equals(String.valueOf(ht.get("USER_ID"))) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id)){%><a href="javascript:view_cons_acar('<%=ht.get("USER_ID")%>')"><%=ht.get("USER_NM")%></a><%}else{%><%=ht.get("USER_NM")%><%}%></td>
                    <td align="center"><%=ht.get("CNT1")%></td>
                    <td align="center"><%=ht.get("CNT2")%></td>
                    <td align="center"><%=ht.get("CNT3")%></td>
                    <td align="center"><%=ht.get("CNT4")%></td>
                    <td align="center"><%=ht.get("CNT5")%></td>
                    <td align="center"><%=ht.get("CNT6")%></td>
                    <td align="center"><%=ht.get("CNT7")%></td>
                    <td align="center"><%=ht.get("CNT8")%></td>
                </tr>
    <%			
    				}%>			  
            </table>
        </td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
	</tr>	
</table>
</form>
</body>
</html>
