<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_accident.*, acar.cont.*, acar.car_service.*"%>
<jsp:useBean id="rl_bean" class="acar.car_accident.AccidentBean" scope="page"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	CarServDatabase csd = CarServDatabase.getInstance();
	AddCarAccidDatabase a_cdb = AddCarAccidDatabase.getInstance();
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();
	
	AccidentBean rl_r [] = a_cdb.getCarAccidList(car_mng_id);
	
	//자산양수차량
	Hashtable ht_ac = shDb.getCarAcInfo(car_mng_id);
	
	int count =0;
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function SetCarRent(rent_mng_id,rent_l_cd, car_mng_id, accid_id){
		var theForm = opener.document.AccidentRegForm;
		theForm.rent_mng_id.value = rent_mng_id;
		theForm.rent_l_cd.value = rent_l_cd;
		theForm.car_mng_id.value = car_mng_id;
		theForm.accid_id.value = accid_id;
		opener.ReLoadService2();
		self.close();
	}
//-->
</script>
</head>
<body onLoad="self.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr>
    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고기록표</span></td>
  </tr>
  <tr>
    <td colspan=2 class=line2></td>
  </tr>
  <tr>
    <td class=line colspan=2>
      <table border=0 cellspacing=1 width=100%>
        <tr> 
          <td class=title width=3%>연번</td>
          <td class=title width=10%>계약번호</td>
          <td class=title width=10%>상호</td>
          <td class=title width=5%>고객명</td>
          <td class=title width=6%>사고구분</td>
          <td class=title width=6%>운전자명</td>
          <td class=title width=8%>사고일자</td>
          <td class=title width=20%>사고내용</td>
          <td class=title width=25%>수리내용</td>
					<td class=title width=7%>수리비용</td>
        </tr>
	      <%if(!String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("") && !String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("null")){
	      		count++;
	      %>
          <td align="center"><%=count%></td>
          <td align="center">&nbsp;</td>
          <td align="center"><%=ht_ac.get("CAR_OFF_NM")%></td>
          <td align="center">*****</td>
          <td align="center">*****</td>
          <td align="center">&nbsp;</td>
          <td align="center">*****</td>
          <td>자산양수 차량</td>
          <td>※사고수리내역(자산양수시 평가표에 의함):<%if(!String.valueOf(ht_ac.get("ACCID_SERV_CONT")).equals("") && !String.valueOf(ht_ac.get("ACCID_SERV_CONT")).equals("null")){%><%=ht_ac.get("ACCID_SERV_CONT")%><%}else{%>없음<%}%></td>
					<td align='right'>추정<%=AddUtil.parseDecimal(String.valueOf(ht_ac.get("ACCID_SERV_AMT")))%></td>
        </tr>
	      <%}%>        
        <%for(int i=0; i<rl_r.length; i++){
          	rl_bean = rl_r[i];
        		s_bean = a_csd.getService(car_mng_id, rl_bean.getAccid_id());
						String accid_cont = "";
						if(!String.valueOf(rl_bean.getAccid_cont()).equals("")){
							accid_cont = String.valueOf(rl_bean.getAccid_cont());
						}
						if(!String.valueOf(rl_bean.getAccid_cont()).equals(String.valueOf(rl_bean.getAccid_cont2()))){
							accid_cont = accid_cont+" "+String.valueOf(rl_bean.getAccid_cont2());
						}
						if(accid_cont.equals("")){
							accid_cont = String.valueOf(rl_bean.getSub_etc());
						}
						
						if(!String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("") && !String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("null") && s_bean.getRent_l_cd().equals(String.valueOf(ht_ac.get("RENT_L_CD"))) && s_bean.getServ_st().equals("7")){
							continue;
						}
						count++;
				%>
        <tr> 
          <td align="center"><%=count%></td>
          <td align="center"><%= rl_bean.getRent_l_cd() %></td>
          <td align="center"><%=rl_bean.getFirm_nm()%></td>
          <td align="center"><%=rl_bean.getClient_nm()%></td>
          <td align="center"><%=rl_bean.getAccid_st()%></td>
          <td align="center"><%=rl_bean.getOur_driver()%></td>
          <td align="center"><%=AddUtil.ChangeDate2(rl_bean.getAccid_dt().substring(0,8))%></td>
          <td>
            <table width=100% border=0 cellspacing=0 cellpadding=3>
              <tr>
                <td>
                  <%=accid_cont%>
                </td>
							</tr>
            </table>
          </td>
          <td>
            <table width=100% border=0 cellspacing=0 cellpadding=3>
              <tr>
                <td>
									<%if((s_bean.getServ_st().equals("2")||s_bean.getServ_st().equals("3")||s_bean.getServ_st().equals("4")||s_bean.getServ_st().equals("7"))&&(AddUtil.parseInt(AddUtil.replace(s_bean.getServ_dt(),"-",""))>20031231)){
											ServItem2Bean si_r [] = csd.getServItem2All(s_bean.getCar_mng_id(), s_bean.getServ_id());
             					for(int j=0; j<si_r.length; j++){
             						si_bean = si_r[j];
             						if(j==si_r.length-1){
             							out.print(si_bean.getItem());
             						}else{
             							out.print(si_bean.getItem()+",");
             						}
             					}
             				}else{
             			%>
                	<%=s_bean.getRep_cont()%>
                  <%}%>
								</td>
              </tr>
            </table>
          </td>
					<td align='right'><%=AddUtil.parseDecimal(s_bean.getTot_amt())%></td>
        </tr>
        <%}%>
        <%if(count == 0){%>
        <tr>
          <td colspan=10 align=center height=25>등록된 데이타가 없습니다.</td>
        </tr>
        <%}%>
      </table>
    </td>
  </tr>
</table>
</body>
</html>