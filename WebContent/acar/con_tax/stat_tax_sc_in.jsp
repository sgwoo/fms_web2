<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init(){		
		setupEvents();
	}	
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body >
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"1":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String s_est_y = request.getParameter("s_est_y")==null?"":request.getParameter("s_est_y");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector taxs = t_db.getTaxStatList2(s_est_y);
	int tax_size = taxs.size();
	
	int cnt[]  = new int[7];
	long amt[] = new long[7];
	
	String mng_mode = ""; 
	if(nm_db.getWorkAuthUser("개별소비세담당",user_id) || nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){
		mng_mode = "A";
	}
%>
<form name='form1' method='post'>
<input type='hidden' name='tax_size' value='<%=tax_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr>
		<td class='line' width='100%' >			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                    <td width="4%" rowspan="3" class='title'>연번</td>
                    <td colspan="2" class='title'>귀속월</td>					
                    <td colspan="10" class='title'>등록현황</td>
                    <td colspan="4" class='title'>납부현황</td>
              </tr>			
                <tr>
                  <td width="6%" rowspan="2" class='title'>발생</td>
                  <!--  <td width="5%" rowspan="2" class='title'>처리</td>-->
                  <td width="6%" rowspan="2" class='title'>납부</td>
                  <td class='title' colspan="2">장기대여</td>
                    <td class='title' colspan="2">매각차량</td>
                    <td class='title' colspan="2">용도변경</td>
                    <td class='title' colspan="2">-</td>										
					<td class='title' colspan="2">계</td>
                    <td class='title' colspan="2">미납금</td>										
                    <td class='title' colspan="2">납부금</td>
                </tr>
                <tr>
                    <%for(int i = 0 ; i < 7 ; i++){%>
                    <td width='4%' class='title'>대수</td>
                    <td width='8%' class='title'>금액</td>
                    <%}%>
                </tr>
<%	if(tax_size > 0){%>
          <%for(int i = 0 ; i < tax_size ; i++){
				Hashtable tax = (Hashtable)taxs.elementAt(i);
				
				String pay_mon = String.valueOf(tax.get("DT"));
				
				if(String.valueOf(tax.get("DT2")).equals("200812")) pay_mon = "200901";
				
				if(String.valueOf(tax.get("DT2")).equals("200901")) pay_mon = "200904";
				if(String.valueOf(tax.get("DT2")).equals("200902")) pay_mon = "200904";
				if(String.valueOf(tax.get("DT2")).equals("200903")) pay_mon = "200904";
				if(String.valueOf(tax.get("DT2")).equals("200904")) pay_mon = "200907";
				if(String.valueOf(tax.get("DT2")).equals("200905")) pay_mon = "200907";
				if(String.valueOf(tax.get("DT2")).equals("200906")) pay_mon = "200907";
				if(String.valueOf(tax.get("DT2")).equals("200907")) pay_mon = "200910";
				if(String.valueOf(tax.get("DT2")).equals("200908")) pay_mon = "200910";
				if(String.valueOf(tax.get("DT2")).equals("200909")) pay_mon = "200910";
				if(String.valueOf(tax.get("DT2")).equals("200910")) pay_mon = "201001";
				if(String.valueOf(tax.get("DT2")).equals("200911")) pay_mon = "201001";
				if(String.valueOf(tax.get("DT2")).equals("200912")) pay_mon = "201001";
				
				if(String.valueOf(tax.get("DT2")).equals("201001")) pay_mon = "201004";
				if(String.valueOf(tax.get("DT2")).equals("201002")) pay_mon = "201004";
				if(String.valueOf(tax.get("DT2")).equals("201003")) pay_mon = "201004";
				if(String.valueOf(tax.get("DT2")).equals("201004")) pay_mon = "201007";
				if(String.valueOf(tax.get("DT2")).equals("201005")) pay_mon = "201007";
				if(String.valueOf(tax.get("DT2")).equals("201006")) pay_mon = "201007";
				if(String.valueOf(tax.get("DT2")).equals("201007")) pay_mon = "201010";
				if(String.valueOf(tax.get("DT2")).equals("201008")) pay_mon = "201010";
				if(String.valueOf(tax.get("DT2")).equals("201009")) pay_mon = "201010";
				if(String.valueOf(tax.get("DT2")).equals("201010")) pay_mon = "201101";
				if(String.valueOf(tax.get("DT2")).equals("201011")) pay_mon = "201101";
				if(String.valueOf(tax.get("DT2")).equals("201012")) pay_mon = "201101";
				
				if(String.valueOf(tax.get("DT2")).equals("201101")) pay_mon = "201104";
				if(String.valueOf(tax.get("DT2")).equals("201102")) pay_mon = "201104";
				if(String.valueOf(tax.get("DT2")).equals("201103")) pay_mon = "201104";
				if(String.valueOf(tax.get("DT2")).equals("201104")) pay_mon = "201107";
				if(String.valueOf(tax.get("DT2")).equals("201105")) pay_mon = "201107";
				if(String.valueOf(tax.get("DT2")).equals("201106")) pay_mon = "201107";
				if(String.valueOf(tax.get("DT2")).equals("201107")) pay_mon = "201110";
				if(String.valueOf(tax.get("DT2")).equals("201108")) pay_mon = "201110";
				if(String.valueOf(tax.get("DT2")).equals("201109")) pay_mon = "201110";
				if(String.valueOf(tax.get("DT2")).equals("201110")) pay_mon = "201201";
				if(String.valueOf(tax.get("DT2")).equals("201111")) pay_mon = "201201";
				if(String.valueOf(tax.get("DT2")).equals("201112")) pay_mon = "201201";
				
				if(String.valueOf(tax.get("DT2")).equals("201201")) pay_mon = "201204";
				if(String.valueOf(tax.get("DT2")).equals("201202")) pay_mon = "201204";
				if(String.valueOf(tax.get("DT2")).equals("201203")) pay_mon = "201204";
				if(String.valueOf(tax.get("DT2")).equals("201204")) pay_mon = "201207";
				if(String.valueOf(tax.get("DT2")).equals("201205")) pay_mon = "201207";
				if(String.valueOf(tax.get("DT2")).equals("201206")) pay_mon = "201207";
				if(String.valueOf(tax.get("DT2")).equals("201207")) pay_mon = "201210";
				if(String.valueOf(tax.get("DT2")).equals("201208")) pay_mon = "201210";
				if(String.valueOf(tax.get("DT2")).equals("201209")) pay_mon = "201210";
				if(String.valueOf(tax.get("DT2")).equals("201210")) pay_mon = "201301";
				if(String.valueOf(tax.get("DT2")).equals("201211")) pay_mon = "201301";
				if(String.valueOf(tax.get("DT2")).equals("201212")) pay_mon = "201301";

				if(String.valueOf(tax.get("DT2")).equals("201301")) pay_mon = "201304";
				if(String.valueOf(tax.get("DT2")).equals("201302")) pay_mon = "201304";
				if(String.valueOf(tax.get("DT2")).equals("201303")) pay_mon = "201304";
				if(String.valueOf(tax.get("DT2")).equals("201304")) pay_mon = "201307";
				if(String.valueOf(tax.get("DT2")).equals("201305")) pay_mon = "201307";
				if(String.valueOf(tax.get("DT2")).equals("201306")) pay_mon = "201307";
				if(String.valueOf(tax.get("DT2")).equals("201307")) pay_mon = "201310";
				if(String.valueOf(tax.get("DT2")).equals("201308")) pay_mon = "201310";
				if(String.valueOf(tax.get("DT2")).equals("201309")) pay_mon = "201310";
				if(String.valueOf(tax.get("DT2")).equals("201310")) pay_mon = "201401";
				if(String.valueOf(tax.get("DT2")).equals("201311")) pay_mon = "201401";
				if(String.valueOf(tax.get("DT2")).equals("201312")) pay_mon = "201401";

				if(String.valueOf(tax.get("DT2")).equals("201401")) pay_mon = "201404";
				if(String.valueOf(tax.get("DT2")).equals("201402")) pay_mon = "201404";
				if(String.valueOf(tax.get("DT2")).equals("201403")) pay_mon = "201404";
				if(String.valueOf(tax.get("DT2")).equals("201404")) pay_mon = "201407";
				if(String.valueOf(tax.get("DT2")).equals("201405")) pay_mon = "201407";
				if(String.valueOf(tax.get("DT2")).equals("201406")) pay_mon = "201407";
				if(String.valueOf(tax.get("DT2")).equals("201407")) pay_mon = "201410";
				if(String.valueOf(tax.get("DT2")).equals("201408")) pay_mon = "201410";
				if(String.valueOf(tax.get("DT2")).equals("201409")) pay_mon = "201410";
				if(String.valueOf(tax.get("DT2")).equals("201410")) pay_mon = "201501";
				if(String.valueOf(tax.get("DT2")).equals("201411")) pay_mon = "201501";
				if(String.valueOf(tax.get("DT2")).equals("201412")) pay_mon = "201501";

				if(String.valueOf(tax.get("DT2")).equals("201501")) pay_mon = "201504";
				if(String.valueOf(tax.get("DT2")).equals("201502")) pay_mon = "201504";
				if(String.valueOf(tax.get("DT2")).equals("201503")) pay_mon = "201504";
				if(String.valueOf(tax.get("DT2")).equals("201504")) pay_mon = "201507";
				if(String.valueOf(tax.get("DT2")).equals("201505")) pay_mon = "201507";
				if(String.valueOf(tax.get("DT2")).equals("201506")) pay_mon = "201507";
				if(String.valueOf(tax.get("DT2")).equals("201507")) pay_mon = "201510";
				if(String.valueOf(tax.get("DT2")).equals("201508")) pay_mon = "201510";
				if(String.valueOf(tax.get("DT2")).equals("201509")) pay_mon = "201510";
				if(String.valueOf(tax.get("DT2")).equals("201510")) pay_mon = "201601";
				if(String.valueOf(tax.get("DT2")).equals("201511")) pay_mon = "201601";
				if(String.valueOf(tax.get("DT2")).equals("201512")) pay_mon = "201601";

				if(String.valueOf(tax.get("DT2")).equals("201601")) pay_mon = "201604";
				if(String.valueOf(tax.get("DT2")).equals("201602")) pay_mon = "201604";
				if(String.valueOf(tax.get("DT2")).equals("201603")) pay_mon = "201604";
				if(String.valueOf(tax.get("DT2")).equals("201604")) pay_mon = "201607";
				if(String.valueOf(tax.get("DT2")).equals("201605")) pay_mon = "201607";
				if(String.valueOf(tax.get("DT2")).equals("201606")) pay_mon = "201607";
				if(String.valueOf(tax.get("DT2")).equals("201607")) pay_mon = "201610";
				if(String.valueOf(tax.get("DT2")).equals("201608")) pay_mon = "201610";
				if(String.valueOf(tax.get("DT2")).equals("201609")) pay_mon = "201610";
				if(String.valueOf(tax.get("DT2")).equals("201610")) pay_mon = "201701";
				if(String.valueOf(tax.get("DT2")).equals("201611")) pay_mon = "201701";
				if(String.valueOf(tax.get("DT2")).equals("201612")) pay_mon = "201701";

				if(String.valueOf(tax.get("DT2")).equals("201701")) pay_mon = "201704";
				if(String.valueOf(tax.get("DT2")).equals("201702")) pay_mon = "201704";
				if(String.valueOf(tax.get("DT2")).equals("201703")) pay_mon = "201704";
				if(String.valueOf(tax.get("DT2")).equals("201704")) pay_mon = "201707";
				if(String.valueOf(tax.get("DT2")).equals("201705")) pay_mon = "201707";
				if(String.valueOf(tax.get("DT2")).equals("201706")) pay_mon = "201707";
				if(String.valueOf(tax.get("DT2")).equals("201707")) pay_mon = "201710";
				if(String.valueOf(tax.get("DT2")).equals("201708")) pay_mon = "201710";
				if(String.valueOf(tax.get("DT2")).equals("201709")) pay_mon = "201710";
				if(String.valueOf(tax.get("DT2")).equals("201710")) pay_mon = "201801";
				if(String.valueOf(tax.get("DT2")).equals("201711")) pay_mon = "201801";
				if(String.valueOf(tax.get("DT2")).equals("201712")) pay_mon = "201801";
				
				if(!String.valueOf(tax.get("DT3")).equals("")) pay_mon = String.valueOf(tax.get("DT3"));

				%>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><a href="javascript:parent.tax_pay2('<%=tax.get("DT")%>','<%=tax.get("DT2")%>')" onMouseOver="window.status=''; return true"><%=tax.get("DT2")%></a></td>					
                    <!--  <td align='center'><%=tax.get("DT")%></td>-->
                    <td align='center'><a href="javascript:parent.tax_pay('<%=tax.get("DT3")%><%//=pay_mon%>')" onMouseOver="window.status=''; return true"><%=tax.get("DT3")%><%//=pay_mon%></a></td>
                    <td align='center'><%=tax.get("CNT1")%></td>
                    <td align='right'><%=AddUtil.parseDecimal2(String.valueOf(tax.get("AMT1")))%></td>
                    <td align='center'><%=tax.get("CNT2")%></td>
                    <td align='right'><%=AddUtil.parseDecimal2(String.valueOf(tax.get("AMT2")))%></td>
                    <td align='center'><%=tax.get("CNT3")%></td>
                    <td align='right'><%=AddUtil.parseDecimal2(String.valueOf(tax.get("AMT3")))%></td>
                    <td align='center'><%=tax.get("CNT4")%></td>
                    <td align='right'><%=AddUtil.parseDecimal2(String.valueOf(tax.get("AMT4")))%></td>
                    <td align='center'><%=tax.get("CNT0")%></td>
                    <td align='right'><%=AddUtil.parseDecimal2(String.valueOf(tax.get("AMT0")))%></td>
                    <td align='center'><%=tax.get("CNT5")%></td>
                    <td align='right'>					
					<%if(String.valueOf(tax.get("AMT6")).equals("")){%>
					<%	if(mng_mode.equals("A")){%>
					<a href="javascript:parent.tax_all_pay('<%=tax.get("DT2")%>', '<%=tax.get("EST_DT")%>')" title='일괄 납부처리'><%=AddUtil.parseDecimal2(String.valueOf(tax.get("AMT5")))%></a>
					<%	}else{%>
					<%=AddUtil.parseDecimal2(String.valueOf(tax.get("AMT5")))%>
					<%	}%>
					<%}else{%>
					<%=AddUtil.parseDecimal2(String.valueOf(tax.get("AMT5")))%>
					<%}%>
					</td>
                    <td align='center'><%=tax.get("CNT6")%></td>
                    <td align='right'><%=AddUtil.parseDecimal2(String.valueOf(tax.get("AMT6")))%></td>
                </tr>
          <%	
		  		amt[0] 		= amt[0] + AddUtil.parseLong(String.valueOf(tax.get("AMT0")));
			  	amt[1] 		= amt[1] + AddUtil.parseLong(String.valueOf(tax.get("AMT1")));
		  		amt[2] 		= amt[2] + AddUtil.parseLong(String.valueOf(tax.get("AMT2")));
		  		amt[3] 		= amt[3] + AddUtil.parseLong(String.valueOf(tax.get("AMT3")));
		  		amt[4] 		= amt[4] + AddUtil.parseLong(String.valueOf(tax.get("AMT4")));
		  		amt[5] 		= amt[5] + AddUtil.parseLong(String.valueOf(tax.get("AMT5")));
		  		amt[6] 		= amt[6] + AddUtil.parseLong(String.valueOf(tax.get("AMT6")));
				
		  		cnt[0] 		= cnt[0] + Util.parseInt(String.valueOf(tax.get("CNT0")));
		  		cnt[1] 		= cnt[1] + Util.parseInt(String.valueOf(tax.get("CNT1")));
		  		cnt[2] 		= cnt[2] + Util.parseInt(String.valueOf(tax.get("CNT2")));
		  		cnt[3] 		= cnt[3] + Util.parseInt(String.valueOf(tax.get("CNT3")));
		  		cnt[4] 		= cnt[4] + Util.parseInt(String.valueOf(tax.get("CNT4")));
		  		cnt[5] 		= cnt[5] + Util.parseInt(String.valueOf(tax.get("CNT5")));
		  		cnt[6] 		= cnt[6] + Util.parseInt(String.valueOf(tax.get("CNT6")));
		  	}%>
                <tr> 
                    <td class='title' colspan="3">합계</td>
                    <td class='title'><%=Util.parseDecimal(cnt[1])%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(amt[1])%></td>
                    <td class='title'><%=Util.parseDecimal(cnt[2])%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(amt[2])%></td>
                    <td class='title'><%=Util.parseDecimal(cnt[3])%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(amt[3])%></td>
                    <td class='title'><%=Util.parseDecimal(cnt[4])%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(amt[4])%></td>
                    <td class='title'><%=Util.parseDecimal(cnt[0])%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(amt[0])%></td>
                    <td class='title'><%=Util.parseDecimal(cnt[5])%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(amt[5])%></td>
                    <td class='title'><%=Util.parseDecimal(cnt[6])%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(amt[6])%></td>
                </tr>
          </table>
		</td>
<%	}else{%>
	<tr>
		<td class='line' width='100%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
