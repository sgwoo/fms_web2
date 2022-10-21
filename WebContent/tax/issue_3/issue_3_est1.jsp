<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, tax.*, acar.bill_mng.*, acar.client.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	int tae_sum = 0;
	int max_table_line = 3;
	int height = 0;
	String tax_supply = "";
	String tax_value = "";
	String tax_yn= "N";
	
	//선수금 스케줄
	Vector grts = ScdMngDb.getGrtScdList(s_br, "", tax_yn, gubun2);
	int grt_size = grts.size();	
	
	int count = 0;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function client_select(client_id, site_id, firm_nm, rent_mng_id, rent_l_cd, pp_st_nm, rent_st, ext_st, ext_tm){
		var fm = document.form1;
		fm.client_id.value = client_id;	
		fm.site_id.value = site_id;
		fm.firm_nm.value = firm_nm;
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value = rent_l_cd;
		fm.pp_st_nm.value = pp_st_nm;
		fm.rent_st.value = rent_st;
		fm.ext_st.value = ext_st;
		fm.ext_tm.value = ext_tm;
		fm.action = "issue_3_sc1.jsp";
		fm.target = "d_content";
		fm.submit();
	}
//-->
</script>

</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="client_id" value="<%=client_id%>">
  <input type="hidden" name="site_id" value="<%=site_id%>">  
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">  
  <input type="hidden" name="mode" value="<%=mode%>">  
  <input type="hidden" name="firm_nm" value="">  
  <input type="hidden" name="pp_st_nm" value="">  
  <input type="hidden" name="rent_st" value="">
  <input type="hidden" name="ext_st" value="">
  <input type="hidden" name="ext_tm" value="">
<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr> 
      <td></td>
    </tr>  
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선수금 미발행리스트</span></td>
    </tr> 
    <tr><td class=line2></td></tr> 
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
      	
        <tr>
          <td width='3%' class='title'>연번</td>
          <td width='10%' class='title'>계약번호</td>
          <td width='*' class='title'>상호</td>
          <td width='10%' class='title'>차량번호</td>
          <td width='10%' class='title'>차명</td>
          <td width='8%' class='title'>구분</td>
          <!-- <td width='10%' class='title'>공급가</td>
          <td width='9%' class='title'>부가세</td> -->
          <td width='10%' class='title'>합계<br>(공급가+부가세)</td>
          <td width='8%' class='title'>대여개시일</td>
          <td width='8%' class='title'>입금예정일</td>
          <td width='8%' class='title'>입금금액</td>
          <td width='8%' class='title'>입금일자</td>
        </tr>
		<%	if(grt_size > 0){
				for (int i = 0 ; i < grt_size ; i++){
					Hashtable grt = (Hashtable)grts.elementAt(i);
					
					if(String.valueOf(grt.get("RENT_L_CD")).equals("G114HHGR00390") && String.valueOf(grt.get("PP_AMT")).equals("1930500") && String.valueOf(grt.get("EXT_EST_DT")).equals("20150127") ) continue;					
					if(String.valueOf(grt.get("RENT_L_CD")).equals("D113KK7R00356") && String.valueOf(grt.get("PP_AMT")).equals("5000000") && String.valueOf(grt.get("EXT_EST_DT")).equals("20141218") ) continue;
					if(String.valueOf(grt.get("RENT_L_CD")).equals("B118HGHR00007") && String.valueOf(grt.get("PP_AMT")).equals("17780000") && String.valueOf(grt.get("EXT_EST_DT")).equals("20180331") ) continue;
					
					count++;
					
					String td_color = "";
			    	if(String.valueOf(grt.get("USE_YN")).equals("N")) td_color = "class='is'";
			    	
			    	//20191101 추가사항
					String grt_rent_l_cd 		= String.valueOf(grt.get("RENT_L_CD"));
					String grt_rent_mng_id = String.valueOf(grt.get("RENT_MNG_ID"));
					String grt_rent_st 			= String.valueOf(grt.get("RENT_ST"));
					String grt_rent_seq 		= String.valueOf(grt.get("RENT_SEQ"));
					String grt_ext_st 			= String.valueOf(grt.get("EXT_ST"));
					String grt_ext_id 			= String.valueOf(grt.get("EXT_ID"));
					
			    	Vector grts2 = ScdMngDb.getGrtScdList2(grt_rent_l_cd, grt_rent_mng_id, grt_rent_st, grt_rent_seq, grt_ext_st, grt_ext_id);
					int grts2_size = grts2.size();
					int ext_pay_amt_tot = 0;
					String ext_pay_dt = "";
					if(grts2_size>1){	//입금내역이 2건 이상인지 확인
						for(int j=0;j<grts2_size;j++){
							Hashtable grt2 = (Hashtable)grts2.elementAt(j);
							if(!String.valueOf(grt.get("RENT_SUC_DT")).equals("") && String.valueOf(grt.get("SUC_RENT_ST")).equals(grt_rent_st)){
								if(AddUtil.parseInt(String.valueOf(grt.get("RENT_SUC_DT")))<=AddUtil.parseInt(String.valueOf(grt2.get("EXT_PAY_DT")))){
									ext_pay_amt_tot += AddUtil.parseInt(String.valueOf(grt2.get("EXT_PAY_AMT")));
								}
							}else{
								ext_pay_amt_tot += AddUtil.parseInt(String.valueOf(grt2.get("EXT_PAY_AMT")));
							}							
							if(j==grts2_size-1){			ext_pay_dt = String.valueOf(grt2.get("EXT_PAY_DT"));	}	//입금날짜는 마지막건 기준으로 세팅.
						}
					}
					
					//계약승계처리
					if(!String.valueOf(grt.get("RENT_SUC_DT")).equals("") && String.valueOf(grt.get("SUC_RENT_ST")).equals(grt_rent_st))
					{
						//out.println("계약승계처리");
						if(String.valueOf(grt.get("PP_ST_NM")).equals("선납금") && AddUtil.parseInt(String.valueOf(grt.get("PP_SUC_R_AMT")))>0){
							grt.put("EXT_S_AMT",grt.get("PP_SUC_S_AMT"));
							grt.put("EXT_V_AMT",grt.get("PP_SUC_V_AMT"));
							grt.put("PP_AMT",grt.get("PP_SUC_R_AMT"));
						}
						if(String.valueOf(grt.get("PP_ST_NM")).equals("개시대여료") && AddUtil.parseInt(String.valueOf(grt.get("IFEE_SUC_R_AMT")))>0){
							grt.put("EXT_S_AMT",grt.get("IFEE_SUC_S_AMT"));
							grt.put("EXT_V_AMT",grt.get("IFEE_SUC_V_AMT"));
							grt.put("PP_AMT",grt.get("IFEE_SUC_R_AMT"));
						}						
					}
					%>		
        <tr>
          <td  <%=td_color%> align="center"><%=count%></td>
          <td <%=td_color%>  align="center">
          <a href="javascript:client_select('<%=grt.get("CLIENT_ID")%>','<%=grt.get("SITE_ID")%>','<%=grt.get("FIRM_NM")%>','<%=grt.get("RENT_MNG_ID")%>','<%=grt.get("RENT_L_CD")%>','<%=grt.get("PP_ST_NM")%>','<%=grt.get("RENT_ST")%>','<%=grt.get("EXT_ST")%>','<%=grt.get("EXT_TM")%>')"><%=grt.get("RENT_L_CD")%></a></td>
          <td <%=td_color%>  align="center"><span title='<%=grt.get("FIRM_NM")%>(<%=grt.get("CLIENT_ID")%>)'><%=AddUtil.subData(String.valueOf(grt.get("FIRM_NM")), 15)%></td>
          <td <%=td_color%>  align="center"><%=grt.get("CAR_NO")%></td>
          <td  <%=td_color%> align="center"><span title='<%=grt.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(grt.get("CAR_NM")), 6)%></td>
          <td  <%=td_color%> align="center"><%=grt.get("PP_ST_NM")%><%if(!String.valueOf(grt.get("PP_ST_NM")).equals("승계수수료")&&!String.valueOf(grt.get("RENT_SUC_DT")).equals("")){%>(계약승계)<%}%></td>
          <%-- <td  <%=td_color%> align="right"><%=Util.parseDecimal(String.valueOf(grt.get("EXT_S_AMT")))%>원&nbsp;</td> --%>
          <%-- <td  <%=td_color%> align="right"><%=Util.parseDecimal(String.valueOf(grt.get("EXT_V_AMT")))%>원&nbsp;</td> --%>
          <td  <%=td_color%> align="right"><%=Util.parseDecimal(String.valueOf(grt.get("PP_AMT")))%>원&nbsp;</td>
          <td  <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("RENT_START_DT")))%><br><%=AddUtil.ChangeDate2(String.valueOf(grt.get("RENT_SUC_DT")))%></td>
          <td  <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("EXT_EST_DT")))%></td>
          
          <td  <%=td_color%> align="right">
          <%if(grts2_size > 1){%>
          	<%=Util.parseDecimal(String.valueOf(ext_pay_amt_tot))%>원&nbsp;
          <%}else{%>
          	<%=Util.parseDecimal(String.valueOf(grt.get("EXT_PAY_AMT")))%>원&nbsp;
          <%}%>
          </td>
          <td  <%=td_color%> align="center">
   		  <%if(grts2_size > 1 && !ext_pay_dt.equals("")){%>
       		<%=AddUtil.ChangeDate2(ext_pay_dt)%>
       	  <%}else{%>
        	<%if(!String.valueOf(grt.get("EXT_PAY_DT")).equals("")){%><%=AddUtil.ChangeDate2(String.valueOf(grt.get("EXT_PAY_DT")))%><%}%>
       	  <%}%>
          </td>
        </tr>
		<%		}
			}%>
<% 		if(grt_size == 0){%>
		<tr>
		  <td colspan="11" align="center">등록된 데이타가 없습니다.</td>
		</tr>
<% 		}%>					
      </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>	
  </table>
</form>
</body>
</html>
