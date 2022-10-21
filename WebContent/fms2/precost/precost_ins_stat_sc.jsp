<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//기간비용
	function view_precost(cost_ym, cost_st, car_use){
		window.open('view_precost_ins_list.jsp?cost_ym='+cost_ym+'&cost_st='+cost_st+'&car_use='+car_use, "PRECOST_LIST", "left=0, top=0, width=900, height=768, scrollbars=yes, status=yes, resize");
	}
	
	//기간비용
	function view_precost2(cost_ym, cost_st, car_use, com_id){
		window.open('view_precost_ins_list.jsp?cost_ym='+cost_ym+'&cost_st='+cost_st+'&car_use='+car_use+'&com_id='+com_id, "PRECOST_LIST", "left=0, top=0, width=950, height=768, scrollbars=yes, status=yes, resize");
	}

	//기간비용
	function view_precost_chk(chk_st, cost_ym, cost_st, car_use, com_id){
		window.open('view_precost_ins_chk_list.jsp?cost_ym='+cost_ym+'&cost_st='+cost_st+'&car_use='+car_use+'&com_id='+com_id+'&chk_st='+chk_st, "PRECOST_CHK_LIST", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");
	}

	//기간비용
	function view_precost_chk2(chk_st, cost_ym, cost_st, car_use, com_id){
		window.open('view_precost_ins_chk_list2.jsp?cost_ym='+cost_ym+'&cost_st='+cost_st+'&car_use='+car_use+'&com_id='+com_id+'&chk_st='+chk_st, "PRECOST_CHK_LIST", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");
	}

	//기간비용
	function view_precost_chk3(chk_st, cost_ym, cost_st, car_use, com_id){
		window.open('view_precost_ins_chk_list3.jsp?cost_ym='+cost_ym+'&cost_st='+cost_st+'&car_use='+car_use+'&com_id='+com_id+'&chk_st='+chk_st, "PRECOST_CHK_LIST", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");
	}

	//보험스케줄
	function view_ins_scd(cost_ym, pay_yn){
		window.open('view_ins_scd_list.jsp?cost_ym='+cost_ym+'&pay_yn='+pay_yn, "INS_SCD_LIST", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");		
	}

	//보험스케줄
	function view_ins_scd2(cost_ym, pay_yn, car_use, tm_st1){
		window.open('view_ins_scd_list.jsp?cost_ym='+cost_ym+'&pay_yn='+pay_yn+'&car_use='+car_use+'&tm_st1='+tm_st1, "INS_SCD_LIST", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");		
	}
	
	//일자별 보험스케줄
	function view_ins_chk_day(cost_ym, car_use, com_id){
		window.open('view_precost_ins_chk_day_list.jsp?cost_ym='+cost_ym+'&car_use='+car_use+'&com_id='+com_id, "PRECOST_LIST_"+cost_ym+car_use+com_id, "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");
	}
	
	//일자별 보험스케줄
	function view_ins_chk_day4(cost_ym, car_use, com_id){
		
		if(cost_ym > 201612){
			window.open('view_precost_ins_chk_day_list5.jsp?cost_ym='+cost_ym+'&car_use='+car_use+'&com_id='+com_id, "PRECOST_LIST_"+cost_ym+car_use+com_id, "left=0, top=0, width=950, height=968, scrollbars=yes, status=yes, resize");
		}else{
			window.open('view_precost_ins_chk_day_list4.jsp?cost_ym='+cost_ym+'&car_use='+car_use+'&com_id='+com_id, "PRECOST_LIST_"+cost_ym+car_use+com_id, "left=0, top=0, width=950, height=968, scrollbars=yes, status=yes, resize");
		}
	}

	//감사용데이타
	function print_precode_ins(st, cost_ym, car_use, com_id){
		if(st==1)	window.open('print_precost_ins_1.jsp?cost_ym='+cost_ym+'&car_use='+car_use+'&com_id='+com_id, "PRECOST_LIST", "left=0, top=0, width=1250, height=768, scrollbars=yes, status=yes, resize");
		if(st==2)	window.open('print_precost_ins_2.jsp?cost_ym='+cost_ym+'&car_use='+car_use+'&com_id='+com_id, "PRECOST_LIST", "left=0, top=0, width=1050, height=768, scrollbars=yes, status=yes, resize");
		if(st==3)	window.open('print_precost_ins_3.jsp?cost_ym='+cost_ym+'&car_use='+car_use+'&com_id='+com_id, "PRECOST_LIST", "left=0, top=0, width=1450, height=768, scrollbars=yes, status=yes, resize");
		if(st==4)	window.open('print_precost_ins_4.jsp?cost_ym='+cost_ym+'&car_use='+car_use+'&com_id='+com_id, "PRECOST_LIST", "left=0, top=0, width=1450, height=768, scrollbars=yes, status=yes, resize");
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
	
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	//기간비용
	Vector costs = ai_db.getInsurPrecostStat3(brch_id, gubun1);
	int cost_size = costs.size();
	
	//납부보험료
	Vector scds = ai_db.getInsurScdPayAmtStat3(brch_id, gubun1);
	int scd_size = scds.size();
	
	//발생보험료
	Vector scds4 = ai_db.getInsurScdReqAmtStat(brch_id, gubun1);
	int scd_size4 = scds4.size();

	//납부예정보험료
	Vector scds2 = ai_db.getInsurScdEstAmtStat(brch_id);
	int scd_size2 = scds2.size();
	
	//납부보험료-보험사별
	Vector scds3 = ai_db.getInsurScdComAmtStat(brch_id, gubun1);
	int scd_size3 = scds3.size();
	
	long sum0 = 0;
	long sum1 = 0;
	long sum2 = 0;
	long sum3 = 0;
	long sum4 = 0;
	long sum5 = 0;
	long sum6 = 0;
	long sum7 = 0;
	long sum8 = 0;
	long sum9 = 0;
	long sum10 = 0;
	long sum11 = 0;
	long sum12 = 0;
	long sum13 = 0;
	long sum14 = 0;
	long sum15 = 0;
	long sum16 = 0;
	long sum17 = 0;
	long sum18 = 0;
	long sum19 = 0;
	long sum20 = 0;
	long sum21 = 0;
	long sum22 = 0;
	long sum23 = 0;
	long sum24 = 0;
	long sum25 = 0;
	long sum26 = 0;
	long sum27 = 0;
	long sum28 = 0;
	long sum29 = 0;
	long sum30 = 0;
	
	int  cnt1 = 0;
	int  cnt2 = 0;
	int  cnt3 = 0;
	int  cnt4 = 0;
	int  cnt5 = 0;
	int  cnt6 = 0;
	int  cnt7 = 0;
	int  cnt8 = 0;
	int  cnt9 = 0;
	int  cnt10 = 0;
	int  cnt11 = 0;
	int  cnt12 = 0;
	int  cnt13 = 0;
	int  cnt14 = 0;
	int  cnt15 = 0;
	int  cnt16 = 0;
	int  cnt17 = 0;
	int  cnt18 = 0;
	int  cnt19 = 0;
	int  cnt20 = 0;
	int  cnt21 = 0;
	int  cnt22 = 0;
	int  cnt23 = 0;
	int  cnt24 = 0;
	int  cnt25 = 0;
	int  cnt26 = 0;
	int  cnt27 = 0;
	int  cnt28 = 0;
	int  cnt29 = 0;
	int  cnt30 = 0;
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
		<td align="right">
		  <a href="javascript:print_precode_ins(1,'<%=gubun1%>','','')">[기간비용 인쇄화면]</a>&nbsp;
		  <a href="javascript:print_precode_ins(3,'<%=gubun1%>','','')">[발생보험료 인쇄화면]</a>&nbsp;
		  <a href="javascript:print_precode_ins(4,'<%=gubun1%>','','')">[납부보험료 인쇄화면]</a>&nbsp;
		  <a href="javascript:print_precode_ins(2,'<%=gubun1%>','','')">[납부현황 인쇄화면]
		</a></td>
	</tr>	
	
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기간비용</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='3%' rowspan="2" class='title'>월</td>
            <td colspan="2" class='title'>총합계</td>
            <td width='6%' rowspan="2" class='title'>보험사</td>
            <td class='title' colspan="3">합계</td>
            <td colspan="3" class='title'>영업용</td>
            <td colspan="3" class='title'>업무용</td>
          </tr>
          <tr>
            <td width='10%' class='title'>당월산입</td>
            <td width='9%' class='title'>선급잔액</td>
            <td class='title' width="6%">건수</td>
            <td class='title' width="9%">당월산입</td>
            <td class='title' width="9%">선급잔액</td>
            <td class='title' width="6%">건수</td>
            <td class='title' width="9%">당월산입</td>
            <td class='title' width="9%">선급잔액</td>
            <td class='title' width="6%">건수</td>
            <td class='title' width="9%">당월산입</td>
            <td class='title' width="9%">선급잔액</td>
          </tr>
          <%	for(int i = 0 ; i < cost_size ; i++){
					Hashtable ht = (Hashtable)costs.elementAt(i);%>		  
          <tr> 
            <td rowspan="4" style='text-align:center;'><%=ht.get("MM")%></td>
            <td rowspan="4" style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%><a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>
            <td rowspan="4" style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
            <td style='text-align:center;'>렌터카조합</td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT7")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT15")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT16")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT8")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT17")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT18")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT9")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT19")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT20")))%></td>
          </tr>
          <tr> 
            <td style='text-align:center;'>동부화재</td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT4")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT9")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT10")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT5")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT11")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT12")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT6")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT13")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT14")))%></td>
          </tr>
          <tr> 
          	  <td style='text-align:center;'>삼성화재/기타</td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT5")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT6")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT3")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT7")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT8")))%></td>
           
          </tr>
          <tr> 
            <td style='text-align:center;' class="is">소계</td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT0")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT1")))%></td>
            <td style='text-align:right;' class="is"><a href="javascript:view_precost2('<%=ht.get("YM")%>','2','1','')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT1")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','1','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT2")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT2")))%></td>
            <td style='text-align:right;' class="is"><a href="javascript:view_precost2('<%=ht.get("YM")%>','2','2','')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT3")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','2','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT4")))%></td>
          </tr>
<%			
			sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum4  = sum4  + Util.parseLong(String.valueOf(ht.get("AMT4")));
			sum5  = sum5  + Util.parseLong(String.valueOf(ht.get("AMT5")));
			sum6  = sum6  + Util.parseLong(String.valueOf(ht.get("AMT6")));
			sum7  = sum7  + Util.parseLong(String.valueOf(ht.get("AMT7")));
			sum8  = sum8  + Util.parseLong(String.valueOf(ht.get("AMT8")));
			sum9  = sum9  + Util.parseLong(String.valueOf(ht.get("AMT9")));
			sum10 = sum10 + Util.parseLong(String.valueOf(ht.get("AMT10")));
			sum11 = sum11 + Util.parseLong(String.valueOf(ht.get("AMT11")));
			sum12 = sum12 + Util.parseLong(String.valueOf(ht.get("AMT12")));
			sum13 = sum13 + Util.parseLong(String.valueOf(ht.get("AMT13")));
			sum14 = sum14 + Util.parseLong(String.valueOf(ht.get("AMT14")));
			sum15 = sum15 + Util.parseLong(String.valueOf(ht.get("AMT15")));
			sum16 = sum16 + Util.parseLong(String.valueOf(ht.get("AMT16")));
			sum17 = sum17 + Util.parseLong(String.valueOf(ht.get("AMT17")));
			sum18 = sum18 + Util.parseLong(String.valueOf(ht.get("AMT18")));
			sum19 = sum19 + Util.parseLong(String.valueOf(ht.get("AMT19")));
			sum20 = sum20 + Util.parseLong(String.valueOf(ht.get("AMT20")));
			
			cnt1 = cnt1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
			cnt2 = cnt2 + Util.parseInt(String.valueOf(ht.get("CNT2")));
			cnt3 = cnt3 + Util.parseInt(String.valueOf(ht.get("CNT3")));
			cnt4 = cnt4 + Util.parseInt(String.valueOf(ht.get("CNT4")));
			cnt5 = cnt5 + Util.parseInt(String.valueOf(ht.get("CNT5")));
			cnt6 = cnt6 + Util.parseInt(String.valueOf(ht.get("CNT6")));
			cnt7 = cnt7 + Util.parseInt(String.valueOf(ht.get("CNT7")));
			cnt8 = cnt8 + Util.parseInt(String.valueOf(ht.get("CNT8")));
			cnt9 = cnt9 + Util.parseInt(String.valueOf(ht.get("CNT9")));
}%>			  
          <tr> 
            <td rowspan="4" style='text-align:center;' class=title>계</td>
            <td rowspan="4" style='text-align:right;' class=title><%=AddUtil.parseDecimalLong(sum1)%></td>
            <td rowspan="4" style='text-align:right;' class=title><%=AddUtil.parseDecimalLong(sum2)%></td>
            <td style='text-align:center;' class=title>렌터카조합</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum15)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum16)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt8)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum17)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum18)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt9)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum19)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum20)%></td>
          </tr>
          <tr>
            <td style='text-align:center;' class=title>동부화재</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt4)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum9)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum10)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt5)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum11)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum12)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt6)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum13)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum14)%></td>
          </tr>
          <tr>
          	 <td style='text-align:center;' class=title>삼성화재/기타</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt1)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum3)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum4)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt2)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum5)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum6)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt3)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum8)%></td>
            
          </tr>
          <tr>
            <td style='text-align:center;' class=title>소계</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt1+cnt4+cnt7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum3+sum9+sum15)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum4+sum10+sum16)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt2+cnt5+cnt8)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum5+sum11+sum17)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum6+sum12+sum18)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt3+cnt6+cnt9)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum7+sum13+sum19)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum8+sum14+sum20)%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>발생보험료 (발생시점기준)</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='3%' rowspan="2" class='title'>월</td>
            <td colspan="2" class='title'>총합계</td>
            <td width='6%' rowspan="2" class='title'>보험사</td>
            <td class='title' colspan="4">합계</td>
            <td class='title' colspan="4">영업용</td>
            <td class='title' colspan="4">업무용</td>
          </tr>
          <tr>
            <td width='4%' class='title'>건수</td>
            <td width='9%' class='title'>지급</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="8%">지급</td>
            <td class='title' width="6%">환급</td>
            <td class='title' width="8%">소계</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="8%">지급</td>
            <td class='title' width="6%">환급</td>
            <td class='title' width="8%">소계</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="8%">지급</td>
            <td class='title' width="6%">환급</td>
            <td class='title' width="8%">소계</td>
          </tr>
          <%	
		  		sum0 = 0;
		  		sum1 = 0;
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
					sum13 = 0;
					sum14 = 0;
		  		sum15 = 0;
					sum16 = 0;
					sum17 = 0;
					sum18 = 0;
					sum19 = 0;
		  		sum20 = 0;
				
		  		cnt1 = 0;
					cnt2 = 0;
					cnt3 = 0;
					cnt4 = 0;
		  		cnt5 = 0;
					cnt6 = 0;
					cnt7 = 0;
					cnt8 = 0;
					cnt9 = 0;
				
			  	for(int i = 0 ; i < scd_size4 ; i++){
					Hashtable ht = (Hashtable)scds4.elementAt(i);%>		  
          <tr> 
            <td rowspan="4" style='text-align:center;'><a href="javascript:view_ins_chk_day4('<%=ht.get("YM")%>','','')"><%=ht.get("MM")%></a></td>
            <td rowspan="4" style='text-align:center;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT1")))%></td>
            <td rowspan="4" style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT3")))%></td>
            <td style='text-align:center;'>렌터카조합</td> 
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT7")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT19")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT20")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT21")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT8")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT22")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT23")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT24")))%><a href="javascript:view_ins_chk_day4('<%=ht.get("YM")%>','1','9999')">.</a></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT9")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT25")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT26")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT27")))%><a href="javascript:view_ins_chk_day4('<%=ht.get("YM")%>','2','9999')">.</a></td>
          </tr>
          <tr>
            <td style='text-align:center;'>동부화재</td> 
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT4")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT10")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT11")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT12")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT5")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT13")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT14")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT15")))%><a href="javascript:view_ins_chk_day4('<%=ht.get("YM")%>','1','0008')">.</a></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT6")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT16")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT17")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT18")))%><a href="javascript:view_ins_chk_day4('<%=ht.get("YM")%>','2','0008')">.</a></td>
          </tr>
          <tr>
          	 <td style='text-align:center;'>삼성화재/기타</td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT5")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT6")))%><a href="javascript:view_ins_chk_day4('<%=ht.get("YM")%>','1','0007')">.</a></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT3")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT7")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT8")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT9")))%><a href="javascript:view_ins_chk_day4('<%=ht.get("YM")%>','2','0007')">.</a></td>
          </tr>
          <tr>
            <td style='text-align:center;' class="is">소계</td> 
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT1")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT1")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT2")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT3")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT2")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT4")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT5")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT6")))%><a href="javascript:view_ins_chk_day4('<%=ht.get("YM")%>','1','')">.</a></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT3")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT7")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT8")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT9")))%><a href="javascript:view_ins_chk_day4('<%=ht.get("YM")%>','2','')">.</a></td>
          </tr>
<%			
			sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum4  = sum4  + Util.parseLong(String.valueOf(ht.get("AMT4")));
			sum5  = sum5  + Util.parseLong(String.valueOf(ht.get("AMT5")));
			sum6  = sum6  + Util.parseLong(String.valueOf(ht.get("AMT6")));
			sum7  = sum7  + Util.parseLong(String.valueOf(ht.get("AMT7")));
			sum8  = sum8  + Util.parseLong(String.valueOf(ht.get("AMT8")));
			sum9  = sum9  + Util.parseLong(String.valueOf(ht.get("AMT9")));
			sum10 = sum10 + Util.parseLong(String.valueOf(ht.get("AMT10")));
			sum11 = sum11 + Util.parseLong(String.valueOf(ht.get("AMT11")));
			sum12 = sum12 + Util.parseLong(String.valueOf(ht.get("AMT12")));
			sum13 = sum13 + Util.parseLong(String.valueOf(ht.get("AMT13")));
			sum14 = sum14 + Util.parseLong(String.valueOf(ht.get("AMT14")));
			sum15 = sum15 + Util.parseLong(String.valueOf(ht.get("AMT15")));
			sum16 = sum16 + Util.parseLong(String.valueOf(ht.get("AMT16")));
			sum17 = sum17 + Util.parseLong(String.valueOf(ht.get("AMT17")));
			sum18 = sum18 + Util.parseLong(String.valueOf(ht.get("AMT18")));
			sum19 = sum19 + Util.parseLong(String.valueOf(ht.get("AMT19")));
			sum20 = sum20 + Util.parseLong(String.valueOf(ht.get("AMT20")));
			sum21 = sum21 + Util.parseLong(String.valueOf(ht.get("AMT21")));
			sum22 = sum22 + Util.parseLong(String.valueOf(ht.get("AMT22")));
			sum23 = sum23 + Util.parseLong(String.valueOf(ht.get("AMT23")));
			sum24 = sum24 + Util.parseLong(String.valueOf(ht.get("AMT24")));
			sum25 = sum25 + Util.parseLong(String.valueOf(ht.get("AMT25")));
			sum26 = sum26 + Util.parseLong(String.valueOf(ht.get("AMT26")));
			sum27 = sum27 + Util.parseLong(String.valueOf(ht.get("AMT27")));
			
			cnt1 = cnt1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
			cnt2 = cnt2 + Util.parseInt(String.valueOf(ht.get("CNT2")));
			cnt3 = cnt3 + Util.parseInt(String.valueOf(ht.get("CNT3")));
			cnt4 = cnt4 + Util.parseInt(String.valueOf(ht.get("CNT4")));
			cnt5 = cnt5 + Util.parseInt(String.valueOf(ht.get("CNT5")));
			cnt6 = cnt6 + Util.parseInt(String.valueOf(ht.get("CNT6")));
			cnt7 = cnt7 + Util.parseInt(String.valueOf(ht.get("CNT7")));
			cnt8 = cnt8 + Util.parseInt(String.valueOf(ht.get("CNT8")));
			cnt9 = cnt9 + Util.parseInt(String.valueOf(ht.get("CNT9")));
}%>			  
          <tr> 
            <td rowspan="4" style='text-align:center;' class=title>계</td>
            <td rowspan="4" style='text-align:center;' class=title><%=AddUtil.parseDecimalLong(cnt1+cnt4+cnt7)%></td>
            <td rowspan="4"  style='text-align:right;' class=title><%=AddUtil.parseDecimalLong(sum3+sum12+sum21)%></td>
            <td style='text-align:center;' class=title>렌터카조합</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum19)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum20)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum21)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt8)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum22)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum23)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum24)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt9)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum25)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum26)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum27)%></td>
          </tr>
          <tr>
            <td style='text-align:center;' class=title>동부화재</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt4)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum10)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum11)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum12)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt5)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum13)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum14)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum15)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt6)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum16)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum17)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum18)%></td>
          </tr>
          <tr>
          	 <td style='text-align:center;' class=title>삼성화재/기타</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt1)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum1)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum2)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum3)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt2)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum4)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum5)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum6)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt3)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum8)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum9)%></td>
            
          </tr>
          <tr>
            <td style='text-align:center;' class=title>소계</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt1+cnt4+cnt7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum1+sum10+sum19)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum2+sum11+sum20)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum3+sum12+sum21)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt2+cnt5+cnt8)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum4+sum13+sum22)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum5+sum14+sum23)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum6+sum15+sum24)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt3+cnt6+cnt9)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum7+sum16+sum25)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum8+sum17+sum26)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum9+sum18+sum27)%></td>
          </tr>
        </table>
      </td>
    </tr>    
    <tr>
        <td></td>
    </tr>
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>납부보험료 (지출시점기준, 환급분 포함)</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='3%' rowspan="2" class='title'>월</td>
            <td colspan="2" class='title'>총합계</td>
            <td width='6%' rowspan="2" class='title'>보험사</td>
            <td class='title' colspan="4">합계</td>
            <td class='title' colspan="4">영업용</td>
            <td class='title' colspan="4">업무용</td>
          </tr>
          <tr>
            <td width='4%' class='title'>건수</td>
            <td width='9%' class='title'>지급</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="8%">지급</td>
            <td class='title' width="6%">환급</td>
            <td class='title' width="8%">소계</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="8%">지급</td>
            <td class='title' width="6%">환급</td>
            <td class='title' width="8%">소계</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="8%">지급</td>
            <td class='title' width="6%">환급</td>
            <td class='title' width="8%">소계</td>
          </tr>
          <%	
		  		sum0 = 0;
		  		sum1 = 0;
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
					sum13 = 0;
					sum14 = 0;
		  		sum15 = 0;
					sum16 = 0;
					sum17 = 0;
					sum18 = 0;
					sum19 = 0;
		  		sum20 = 0;
					sum21 = 0;
					sum22 = 0;
					sum23 = 0;
					sum24 = 0;
		  		sum25 = 0;
					sum26 = 0;
					sum27 = 0;
					sum28 = 0;
					sum29 = 0;
		  		sum30 = 0;
				
		  		cnt1 = 0;
					cnt2 = 0;
					cnt3 = 0;
					cnt4 = 0;
		  		cnt5 = 0;
					cnt6 = 0;
					cnt7 = 0;
					cnt8 = 0;
					cnt9 = 0;
				
			  	for(int i = 0 ; i < scd_size ; i++){
					Hashtable ht = (Hashtable)scds.elementAt(i);%>		  
          <tr> 
            <td rowspan="4" style='text-align:center;'><a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','','')"><%=ht.get("MM")%></a></td>
            <td rowspan="4" style='text-align:center;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT1")))%></td>
            <td rowspan="4" style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT3")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','')"></a>--></td>
            <td style='text-align:center;'>렌터카조합</td> 
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT7")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT19")))%><!--<a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','1','','0010')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT20")))%><!--<a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','2','','0010')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT21")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','','')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT8")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT22")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','1','1')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT23")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','1','2')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT24")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','1','')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT9")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT25")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','2','1')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT26")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','2','2')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT27")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','2','')"></a>--></td>
          </tr>
          <tr>
            <td style='text-align:center;'>동부화재</td> 
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT4")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT10")))%><!--<a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','1','','0008')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT11")))%><!--<a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','2','','0008')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT12")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','','')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT5")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT13")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','1','1')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT14")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','1','2')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT15")))%><a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','1','0008')">.</a></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT6")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT16")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','2','1')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT17")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','2','2')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT18")))%><a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','2','0008')">.</a></td>
          </tr>
          <tr>           
          	 <td style='text-align:center;'>삼성화재/기타</td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%><!--<a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','1','','0007')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%><!--<a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','2','','0007')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','','')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','1','1')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT5")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','1','2')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT6")))%><a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','1','0007')">.</a></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT3")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT7")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','2','1')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT8")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','2','2')"></a>--></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT9")))%><a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','2','0007')">.</a></td>
          </tr>
          <tr>
            <td style='text-align:center;' class="is">소계</td> 
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT1")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT1")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','','1')"></a>--></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT2")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','','2')"></a>--></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT3")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','','')"></a>--></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT2")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT4")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','1','1')"></a>--></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT5")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','1','2')"></a>--></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT6")))%><a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','1','')">.</a></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT3")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT7")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','2','1')"></a>--></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT8")))%><!--<a href="javascript:chk_ins_scd('<%=ht.get("YM")%>','1','2','2')"></a>--></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT9")))%><a href="javascript:view_ins_chk_day('<%=ht.get("YM")%>','2','')">.</a></td>
          </tr>
<%			
			sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum4  = sum4  + Util.parseLong(String.valueOf(ht.get("AMT4")));
			sum5  = sum5  + Util.parseLong(String.valueOf(ht.get("AMT5")));
			sum6  = sum6  + Util.parseLong(String.valueOf(ht.get("AMT6")));
			sum7  = sum7  + Util.parseLong(String.valueOf(ht.get("AMT7")));
			sum8  = sum8  + Util.parseLong(String.valueOf(ht.get("AMT8")));
			sum9  = sum9  + Util.parseLong(String.valueOf(ht.get("AMT9")));
			sum10 = sum10 + Util.parseLong(String.valueOf(ht.get("AMT10")));
			sum11 = sum11 + Util.parseLong(String.valueOf(ht.get("AMT11")));
			sum12 = sum12 + Util.parseLong(String.valueOf(ht.get("AMT12")));
			sum13 = sum13 + Util.parseLong(String.valueOf(ht.get("AMT13")));
			sum14 = sum14 + Util.parseLong(String.valueOf(ht.get("AMT14")));
			sum15 = sum15 + Util.parseLong(String.valueOf(ht.get("AMT15")));
			sum16 = sum16 + Util.parseLong(String.valueOf(ht.get("AMT16")));
			sum17 = sum17 + Util.parseLong(String.valueOf(ht.get("AMT17")));
			sum18 = sum18 + Util.parseLong(String.valueOf(ht.get("AMT18")));
			sum19 = sum19 + Util.parseLong(String.valueOf(ht.get("AMT19")));
			sum20 = sum20 + Util.parseLong(String.valueOf(ht.get("AMT20")));
			sum21 = sum21 + Util.parseLong(String.valueOf(ht.get("AMT21")));
			sum22 = sum22 + Util.parseLong(String.valueOf(ht.get("AMT22")));
			sum23 = sum23 + Util.parseLong(String.valueOf(ht.get("AMT23")));
			sum24 = sum24 + Util.parseLong(String.valueOf(ht.get("AMT24")));
			sum25 = sum25 + Util.parseLong(String.valueOf(ht.get("AMT25")));
			sum26 = sum26 + Util.parseLong(String.valueOf(ht.get("AMT26")));
			sum27 = sum27 + Util.parseLong(String.valueOf(ht.get("AMT27")));
			
			cnt1 = cnt1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
			cnt2 = cnt2 + Util.parseInt(String.valueOf(ht.get("CNT2")));
			cnt3 = cnt3 + Util.parseInt(String.valueOf(ht.get("CNT3")));
			cnt4 = cnt4 + Util.parseInt(String.valueOf(ht.get("CNT4")));
			cnt5 = cnt5 + Util.parseInt(String.valueOf(ht.get("CNT5")));
			cnt6 = cnt6 + Util.parseInt(String.valueOf(ht.get("CNT6")));
			cnt7 = cnt7 + Util.parseInt(String.valueOf(ht.get("CNT7")));
			cnt8 = cnt8 + Util.parseInt(String.valueOf(ht.get("CNT8")));
			cnt9 = cnt9 + Util.parseInt(String.valueOf(ht.get("CNT9")));
}%>			  
          <tr> 
            <td rowspan="4" style='text-align:center;' class=title>계</td>
            <td rowspan="4" style='text-align:center;' class=title><%=AddUtil.parseDecimalLong(cnt1+cnt4+cnt7)%></td>
            <td rowspan="4"  style='text-align:right;' class=title><%=AddUtil.parseDecimalLong(sum3+sum12+sum21)%></td>
            <td style='text-align:center;' class=title>렌터카조합</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum19)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum20)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum21)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt8)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum22)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum23)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum24)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt9)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum25)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum26)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum27)%></td>
          </tr>
          <tr>
            <td style='text-align:center;' class=title>동부화재</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt4)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum10)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum11)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum12)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt5)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum13)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum14)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum15)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt6)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum16)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum17)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum18)%></td>
          </tr>
          <tr>
          	 <td style='text-align:center;' class=title>삼성화재/기타</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt1)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum1)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum2)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum3)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt2)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum4)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum5)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum6)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt3)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum8)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum9)%></td>
          </tr>
          <tr>
            <td style='text-align:center;' class=title>소계</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt1+cnt4+cnt7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum1+sum10+sum19)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum2+sum11+sum20)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum3+sum12+sum21)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt2+cnt5+cnt8)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum4+sum13+sum22)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum5+sum14+sum23)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum6+sum15+sum24)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt3+cnt6+cnt9)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum7+sum16+sum25)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum8+sum17+sum26)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum9+sum18+sum27)%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납보험료 (환급분 포함)</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' rowspan="2" class='title'>년월</td>
            <td class='title' colspan="2">합계</td>
            <td class='title' colspan="2">영업용</td>
            <td class='title' colspan="2">업무용</td>
          </tr>
          <tr>
            <td class='title' width="15%">건수</td>
            <td class='title' width="15%">금액</td>
            <td class='title' width="15%">건수</td>
            <td class='title' width="15%">금액</td>
            <td class='title' width="15%">건수</td>
            <td class='title' width="15%">금액</td>
          </tr>
          <%	
		  		sum0 = 0;
		  		sum1 = 0;
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
					sum13 = 0;
					sum14 = 0;
		  		sum15 = 0;
					sum16 = 0;
					sum17 = 0;
					sum18 = 0;
					sum19 = 0;
		  		sum20 = 0;
					sum21 = 0;
					sum22 = 0;
					sum23 = 0;
					sum24 = 0;
		  		sum25 = 0;
					sum26 = 0;
					sum27 = 0;
					sum28 = 0;
					sum29 = 0;
		  		sum30 = 0;
				
		  		cnt1 = 0;
					cnt2 = 0;
					cnt3 = 0;
					cnt4 = 0;
		  		cnt5 = 0;
					cnt6 = 0;
					cnt7 = 0;
					cnt8 = 0;
					cnt9 = 0;
				
			  	for(int i = 0 ; i < scd_size2 ; i++){
					Hashtable ht = (Hashtable)scds2.elementAt(i);%>		  
          <tr> 
            <td align="center"><%=ht.get("YM")%></td>
            <td align="center"><%=AddUtil.parseDecimalLong(Util.parseInt(String.valueOf(ht.get("CNT1")))+Util.parseInt(String.valueOf(ht.get("CNT2"))))%></td>
            <td align="right"><a href="javascript:view_ins_scd('<%=ht.get("YM")%>','0')"><%=AddUtil.parseDecimalLong(Util.parseInt(String.valueOf(ht.get("AMT1")))+Util.parseInt(String.valueOf(ht.get("AMT2"))))%></a></td>
            <td align="center"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
            <td align="center"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
          </tr>
<%			
			sum1 = sum1 + Util.parseLong(String.valueOf(ht.get("CNT1")));
			sum2 = sum2 + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum3 = sum3 + Util.parseLong(String.valueOf(ht.get("CNT2")));
			sum4 = sum4 + Util.parseLong(String.valueOf(ht.get("AMT2")));
}%>			  
          <tr> 
            <td class=title align="center">계</td>
            <td class=title style='text-align:center'><%=AddUtil.parseDecimalLong(sum1+sum3)%></td>
            <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(sum2+sum4)%></td>
            <td class=title style='text-align:center'><%=AddUtil.parseDecimalLong(sum1)%></td>
            <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(sum2)%></td>
            <td class=title style='text-align:center'><%=AddUtil.parseDecimalLong(sum3)%></td>
            <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(sum4)%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험사별 보험료</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='3%' rowspan="3" class='title'>월</td>
            <td width='7%' rowspan="3" class='title'>보험사</td>			
            <td class='title' colspan="6">가입</td>
            <td class='title' colspan="3">기납부</td>
            <td class='title' colspan="3">납부예정</td>			
          </tr>
          <tr>
            <td width="8%" colspan="2" class='title'>소계</td>
            <td width="8%" colspan="2" class='title'>영업용</td>
            <td width="8%" colspan="2" class='title'>업무용</td>
            <td width="8%" rowspan="2" class='title'>소계</td>
            <td width="8%" rowspan="2" class='title'>영업용</td>
            <td width="8%" rowspan="2" class='title'>업무용</td>
            <td width="8%" rowspan="2" class='title'>소계</td>
            <td width="8%" rowspan="2" class='title'>영업용</td>
            <td width="8%" rowspan="2" class='title'>업무용</td>
          </tr>
          <tr>
            <td width="5%" class='title'>건수</td>
            <td width="10%" class='title'>금액</td>
            <td width="4%" class='title'>건수</td>
            <td width="10%" class='title'>금액</td>
            <td width="4%" class='title'>건수</td>
            <td width="10%" class='title'>금액</td>
          </tr>
          <%	
		  		sum0 = 0;
		  		sum1 = 0;
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
					sum13 = 0;
					sum14 = 0;
		  		sum15 = 0;
					sum16 = 0;
					sum17 = 0;
					sum18 = 0;
					sum19 = 0;
		  		sum20 = 0;
					sum21 = 0;
					sum22 = 0;
					sum23 = 0;
					sum24 = 0;
		  		sum25 = 0;
					sum26 = 0;
					sum27 = 0;
					sum28 = 0;
					sum29 = 0;
		  		sum30 = 0;
				
		  		cnt1 = 0;
					cnt2 = 0;
					cnt3 = 0;
					cnt4 = 0;
		  		cnt5 = 0;
					cnt6 = 0;
					cnt7 = 0;
					cnt8 = 0;
					cnt9 = 0;
				
			  	for(int i = 0 ; i < scd_size3 ; i++){
					Hashtable ht = (Hashtable)scds3.elementAt(i);
					String ins_com_id = String.valueOf(ht.get("INS_COM_ID"));
					String ins_com_nm = c_db.getNameById(String.valueOf(ht.get("INS_COM_ID")),"INS_COM");%>		  
          <tr> 
            <td align="center" style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=ht.get("YM")%></td>
            <td align="center" style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=ins_com_nm%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("REG_CNT0")))%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("REG_AMT0")))%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("REG_CNT1")))%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("REG_AMT1")))%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("REG_CNT2")))%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("REG_AMT2")))%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("PAY_AMT0")))%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("PAY_AMT1")))%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("PAY_AMT2")))%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SCD_AMT0")))%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SCD_AMT1")))%></td>
            <td align="right"  style="font-size:8pt" <%if(String.valueOf(ht.get("INS_COM_ID")).equals("0008"))%>class=is<%%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SCD_AMT2")))%></td>
          </tr>
<%						sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("REG_AMT1")));
						sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("REG_AMT2")));
						sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("PAY_AMT1")));
						sum4  = sum4  + Util.parseLong(String.valueOf(ht.get("PAY_AMT2")));
						sum5  = sum5  + Util.parseLong(String.valueOf(ht.get("SCD_AMT1")));
						sum6  = sum6  + Util.parseLong(String.valueOf(ht.get("SCD_AMT2")));
						
						cnt1  = cnt1  + Util.parseInt(String.valueOf(ht.get("REG_CNT1")));
						cnt2  = cnt2  + Util.parseInt(String.valueOf(ht.get("REG_CNT2")));
						
					if(ins_com_id.equals("0007")){
						sum7  = sum7  + Util.parseLong(String.valueOf(ht.get("REG_AMT1")));
						sum8  = sum8  + Util.parseLong(String.valueOf(ht.get("REG_AMT2")));
						sum9  = sum9  + Util.parseLong(String.valueOf(ht.get("PAY_AMT1")));
						sum10 = sum10 + Util.parseLong(String.valueOf(ht.get("PAY_AMT2")));
						sum11 = sum11 + Util.parseLong(String.valueOf(ht.get("SCD_AMT1")));
						sum12 = sum12 + Util.parseLong(String.valueOf(ht.get("SCD_AMT2")));
						
						cnt7  = cnt7  + Util.parseInt(String.valueOf(ht.get("REG_CNT1")));
						cnt8  = cnt8  + Util.parseInt(String.valueOf(ht.get("REG_CNT2")));
						
					}else if(ins_com_id.equals("0008")){
						sum13 = sum13 + Util.parseLong(String.valueOf(ht.get("REG_AMT1")));
						sum14 = sum14 + Util.parseLong(String.valueOf(ht.get("REG_AMT2")));
						sum15 = sum15 + Util.parseLong(String.valueOf(ht.get("PAY_AMT1")));
						sum16 = sum16 + Util.parseLong(String.valueOf(ht.get("PAY_AMT2")));
						sum17 = sum17 + Util.parseLong(String.valueOf(ht.get("SCD_AMT1")));
						sum18 = sum18 + Util.parseLong(String.valueOf(ht.get("SCD_AMT2")));
						
						cnt13  = cnt13  + Util.parseInt(String.valueOf(ht.get("REG_CNT1")));
						cnt14  = cnt14  + Util.parseInt(String.valueOf(ht.get("REG_CNT2")));
						
					}else if(ins_com_id.equals("0038")){
						sum19 = sum19 + Util.parseLong(String.valueOf(ht.get("REG_AMT1")));
						sum20 = sum20 + Util.parseLong(String.valueOf(ht.get("REG_AMT2")));
						sum21 = sum21 + Util.parseLong(String.valueOf(ht.get("PAY_AMT1")));
						sum22 = sum22 + Util.parseLong(String.valueOf(ht.get("PAY_AMT2")));
						sum23 = sum23 + Util.parseLong(String.valueOf(ht.get("SCD_AMT1")));
						sum24 = sum24 + Util.parseLong(String.valueOf(ht.get("SCD_AMT2")));
						
						cnt19  = cnt19  + Util.parseInt(String.valueOf(ht.get("REG_CNT1")));
						cnt20  = cnt20  + Util.parseInt(String.valueOf(ht.get("REG_CNT2")));
						
					}
}%>			  
         
          <tr>
          	 <td rowspan="4" align="center" class=title>계</td>
            <td class=title align="center">렌터카조합</td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt19+cnt20)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum19+sum20)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt19)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum19)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt20)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum20)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum21+sum22)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum21)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum22)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum23+sum24)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum23)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum24)%></td>
          </tr>
          <tr>
            <td class=title align="center">동부화재</td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt13+cnt14)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum13+sum14)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt13)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum13)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt14)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum14)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum15+sum16)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum15)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum16)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum17+sum18)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum17)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum18)%></td>
          </tr>
           <tr> 
            <td class=title align="center">삼성화재/기타</td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt7+cnt8)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum7+sum8)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt7)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum7)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt8)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum8)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum9+sum10)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum9)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum10)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum11+sum12)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum11)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum12)%></td>
          </tr>
          <tr>
            <td class=title align="center">소계</td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt1+cnt2)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum1+sum2)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt1)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum1)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(cnt2)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum2)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum3+sum4)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum3)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum4)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum5+sum6)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum5)%></td>
            <td class=title style='font-size:8pt; text-align:right'><%=AddUtil.parseDecimalLong(sum6)%></td>
          </tr>
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
