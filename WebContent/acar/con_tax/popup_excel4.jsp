<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function set_amt(){
		var fm = document.form1;	
		var tax_size1 = toInt(fm.tax_size1.value);
		var tax_size2 = toInt(fm.tax_size2.value);
		var tax_size3 = toInt(fm.tax_size3.value);				
		var tax_size = tax_size1+tax_size2+tax_size3;
		
		for(i=0; i<tax_size ; i++){
			if(tax_size == 1){
				fm.sur_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value))*(parseFloat(parseDigit(fm.sur_rate.value))/100));
				fm.spe_tax_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.sur_amt.value))*(parseFloat(parseDigit(fm.tax_rate.value))/100)));
				fm.edu_tax_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.spe_tax_amt.value))*(30/100)));				
				fm.tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))+toInt(parseDigit(fm.edu_tax_amt.value)));		
			}else{
				fm.sur_amt[i].value = parseDecimal(toInt(parseDigit(fm.car_fs_amt[i].value))*(parseFloat(parseDigit(fm.sur_rate[i].value))/100));
				fm.spe_tax_amt[i].value = parseDecimal(th_rnd(toInt(parseDigit(fm.sur_amt[i].value))*(parseFloat(parseDigit(fm.tax_rate[i].value))/100)));
				fm.edu_tax_amt[i].value = parseDecimal(th_rnd(toInt(parseDigit(fm.spe_tax_amt[i].value))*(30/100)));				
				fm.tax_amt[i].value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt[i].value))+toInt(parseDigit(fm.edu_tax_amt[i].value)));					
			}			
		}
		
		for(i=0; i<tax_size1 ; i++){
			fm.h_car_fs_amt[0].value = parseDecimal(toInt(parseDigit(fm.h_car_fs_amt[0].value))+toInt(parseDigit(fm.car_fs_amt[i].value)));
			fm.h_sur_amt[0].value = parseDecimal(toInt(parseDigit(fm.h_sur_amt[0].value))+toInt(parseDigit(fm.sur_amt[i].value)));
			fm.h_spe_tax_amt[0].value = parseDecimal(toInt(parseDigit(fm.h_spe_tax_amt[0].value))+toInt(parseDigit(fm.spe_tax_amt[i].value)));
			fm.h_edu_tax_amt[0].value = parseDecimal(toInt(parseDigit(fm.h_edu_tax_amt[0].value))+toInt(parseDigit(fm.edu_tax_amt[i].value)));
			fm.h_tax_amt[0].value = parseDecimal(toInt(parseDigit(fm.h_tax_amt[0].value))+toInt(parseDigit(fm.tax_amt[i].value)));																
		}					

		for(i=tax_size1; i<tax_size1+tax_size2 ; i++){
			fm.h_car_fs_amt[1].value = parseDecimal(toInt(parseDigit(fm.h_car_fs_amt[1].value))+toInt(parseDigit(fm.car_fs_amt[i].value)));
			fm.h_sur_amt[1].value = parseDecimal(toInt(parseDigit(fm.h_sur_amt[1].value))+toInt(parseDigit(fm.sur_amt[i].value)));
			fm.h_spe_tax_amt[1].value = parseDecimal(toInt(parseDigit(fm.h_spe_tax_amt[1].value))+toInt(parseDigit(fm.spe_tax_amt[i].value)));
			fm.h_edu_tax_amt[1].value = parseDecimal(toInt(parseDigit(fm.h_edu_tax_amt[1].value))+toInt(parseDigit(fm.edu_tax_amt[i].value)));
			fm.h_tax_amt[1].value = parseDecimal(toInt(parseDigit(fm.h_tax_amt[1].value))+toInt(parseDigit(fm.tax_amt[i].value)));
		}					

		for(i=tax_size1+tax_size2; i<tax_size1+tax_size2+tax_size3 ; i++){
			fm.h_car_fs_amt[2].value = parseDecimal(toInt(parseDigit(fm.h_car_fs_amt[2].value))+toInt(parseDigit(fm.car_fs_amt[i].value)));
			fm.h_sur_amt[2].value = parseDecimal(toInt(parseDigit(fm.h_sur_amt[2].value))+toInt(parseDigit(fm.sur_amt[i].value)));
			fm.h_spe_tax_amt[2].value = parseDecimal(toInt(parseDigit(fm.h_spe_tax_amt[2].value))+toInt(parseDigit(fm.spe_tax_amt[i].value)));
			fm.h_edu_tax_amt[2].value = parseDecimal(toInt(parseDigit(fm.h_edu_tax_amt[2].value))+toInt(parseDigit(fm.edu_tax_amt[i].value)));
			fm.h_tax_amt[2].value = parseDecimal(toInt(parseDigit(fm.h_tax_amt[2].value))+toInt(parseDigit(fm.tax_amt[i].value)));
		}					

		for(i=0; i<3; i++){
			fm.h_car_fs_amt[3].value = parseDecimal(toInt(parseDigit(fm.h_car_fs_amt[3].value))+toInt(parseDigit(fm.h_car_fs_amt[i].value)));
			fm.h_sur_amt[3].value = parseDecimal(toInt(parseDigit(fm.h_sur_amt[3].value))+toInt(parseDigit(fm.h_sur_amt[i].value)));
			fm.h_spe_tax_amt[3].value = parseDecimal(toInt(parseDigit(fm.h_spe_tax_amt[3].value))+toInt(parseDigit(fm.h_spe_tax_amt[i].value)));
			fm.h_edu_tax_amt[3].value = parseDecimal(toInt(parseDigit(fm.h_edu_tax_amt[3].value))+toInt(parseDigit(fm.h_edu_tax_amt[i].value)));
			fm.h_tax_amt[3].value = parseDecimal(toInt(parseDigit(fm.h_tax_amt[3].value))+toInt(parseDigit(fm.h_tax_amt[i].value)));
		}		
	}
-->	
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int total_su = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt21 = 0;
	long total_amt22 = 0;
	long total_amt23 = 0;
	long total_amt24 = 0;
	long total_amt25 = 0;
	long total_amt31 = 0;
	long total_amt32 = 0;
	long total_amt33 = 0;
	long total_amt34 = 0;
	long total_amt35 = 0;
	
	
	
	String view_dt = "";
	if(gubun2.equals("1")){//당월-납부
		view_dt = t_db.getViewYM(AddUtil.getDate(1)+""+AddUtil.getDate(2), 1, "YYYY-MM");
	}else{//기간-납부
		view_dt = t_db.getViewYM(AddUtil.getDate(1)+""+AddUtil.getDate(2), 1-AddUtil.parseInt(est_mon), "YYYY-MM");	}
%>
<form name='form1' method='post'>
  <table border="1" cellspacing="0" cellpadding="0" width=990>
    <tr> 
    <td align="center" colspan="13"><font face="돋움" size="5" ><b><%=view_dt%>월 매각에 따른 개별소비세 
      납부건</b> </font></td>
  </tr>
  <tr align="center"> 
      <td width='80'>출고일</td>
      <td width='80'> 매각일자</td>
    <td width='85'>차량번호</td>
    <td width='85'>변경후<br>
      차량번호</td>
    <td width='85'>차량명</td>
      <td width='45'>배기량</td>
      <td width='95'>면세구입가</td>
      <td width='55'>잔가율</td>
      <td width='95'>잔존가</td>
      <td width='55'>특소<br>
      세율</td>
      <td width='70'>개별소비세</td>
    <td width='80'>교육세(특별<br>
      소비세의30%)</td>
    <td width='80'>개별소비세 합계</td>
  </tr>
  <%Vector taxs1 = t_db.getTaxExcelList2(br_id, gubun1, gubun2, gubun3, "2", st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "1", est_mon);
	int tax_size1 = taxs1.size();%>
<input type='hidden' name='tax_size1' value='<%=tax_size1%>'>					
  <%if(tax_size1 > 0){
		for(int i = 0 ; i < tax_size1 ; i++){
			Hashtable tax1 = (Hashtable)taxs1.elementAt(i);%>
  <tr> 
      <td width='80' align='center'><%=tax1.get("DLV_DT")%></td>
      <td width='80' align='center'><%=tax1.get("CONT_DT")%>&nbsp;</td>
    <td width='85' align='center'><%=tax1.get("FIRST_CAR_NO")%></td>
    <td width='85' align='center'><%=tax1.get("CAR_NO2")%></td>
    <td width='85' align='center'><%=tax1.get("CAR_NM")%></td>
      <td width='45' align='center'>1</td>
      <td width='95' align='right'> 
        <input type="text" name="car_fs_amt" value="<%=Util.parseDecimal(String.valueOf(tax1.get("CAR_FS_AMT")))%>" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align='center'>
        <input type="text" name="sur_rate" value="<%=t_db.getSurRate(String.valueOf(tax1.get("DLV_DT")), String.valueOf(tax1.get("CLS_ST")))%>" size="5" class="whitenum">
        %</td>
      <td width='95' align='right'> 
        <input type="text" name="sur_amt" value="" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align='center'>
        <input type="text" name="tax_rate" value="<%=t_db.getTaxRate("특소세", (String)tax1.get("DPM"), (String)tax1.get("DLV_DT"))%>" size="5" class="whitenum">
        %</td>
    <td width='70' align='right'><input type="text" name="spe_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td width='80' align='right'><input type="text" name="edu_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td width='80' align='right'><input type="text" name="tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
  </tr>
  <%	}
	}%>
  <tr> 
      <td width='80' align="center">소계</td>
      <td width='80' align="center">(배기량-1)</td>
    <td width='85' align="center">&nbsp;</td>
    <td width='85'>&nbsp;</td>
    <td width='85'>&nbsp;</td>
      <td width='45'>&nbsp;</td>
      <td width='95' align="right"> 
        <input type="text" name="h_car_fs_amt" value="" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align="right">&nbsp;</td>
      <td width='95' align="right"> 
        <input type="text" name="h_sur_amt" value="" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align="right">&nbsp;</td>
    <td width='70' align="right"><input type="text" name="h_spe_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td width='80' align="right"><input type="text" name="h_edu_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td align="right" width="80"><input type="text" name="h_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
  </tr>
  <%Vector taxs2 = t_db.getTaxExcelList2(br_id, gubun1, gubun2, gubun3, "2", st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "2", est_mon);
	int tax_size2 = taxs2.size();%>
<input type='hidden' name='tax_size2' value='<%=tax_size2%>'>					
  <%if(tax_size2 > 0){
		for(int i = 0 ; i < tax_size2 ; i++){
			Hashtable tax2 = (Hashtable)taxs2.elementAt(i);%>
  <tr> 
      <td width='80' align='center'><%=tax2.get("DLV_DT")%></td>
      <td width='80' align='center'><%=tax2.get("CONT_DT")%>&nbsp;</td>
    <td width='85' align='center'><%=tax2.get("FIRST_CAR_NO")%></td>
    <td width='85' align='center'><%=tax2.get("CAR_NO2")%></td>
    <td width='85' align='center'><%=tax2.get("CAR_NM")%></td>
      <td width='45' align='center'>2</td>
      <td width='95' align='right'> 
        <input type="text" name="car_fs_amt" value="<%=Util.parseDecimal(String.valueOf(tax2.get("CAR_FS_AMT")))%>" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align='center'>
        <input type="text" name="sur_rate" value="<%=t_db.getSurRate(String.valueOf(tax2.get("DLV_DT")), String.valueOf(tax2.get("CLS_ST")))%>" size="5" class="whitenum">
        %</td>
      <td width='95' align='right'> 
        <input type="text" name="sur_amt" value="" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align='center'>
        <input type="text" name="tax_rate" value="<%=t_db.getTaxRate("특소세", (String)tax2.get("DPM"), (String)tax2.get("DLV_DT"))%>" size="5" class="whitenum">
        %</td>
    <td width='70' align='right'><input type="text" name="spe_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td width='80' align='right'><input type="text" name="edu_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td width='80' align='right'><input type="text" name="tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
  </tr>
  <%	}
	}%>
  <tr> 
      <td width='80' align="center">소계</td>
      <td width='80' align="center">(배기량-2)</td>
    <td width='85' align="center">&nbsp;</td>
    <td width='85'>&nbsp;</td>
    <td width='85'>&nbsp;</td>
      <td width='45'>&nbsp;</td>
      <td width='95' align="right"> 
        <input type="text" name="h_car_fs_amt" value="" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align="right">&nbsp;</td>
      <td width='95' align="right"> 
        <input type="text" name="h_sur_amt" value="" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align="right">&nbsp;</td>
    <td width='70' align="right"><input type="text" name="h_spe_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td width='80' align="right"><input type="text" name="h_edu_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td align="right" width="80"><input type="text" name="h_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
  </tr>
  <%Vector taxs3 = t_db.getTaxExcelList2(br_id, gubun1, gubun2, gubun3, "2", st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "3", est_mon);
	int tax_size3 = taxs3.size();%>
<input type='hidden' name='tax_size3' value='<%=tax_size3%>'>					
  <%if(tax_size3 > 0){
		for(int i = 0 ; i < tax_size3 ; i++){
			Hashtable tax3 = (Hashtable)taxs3.elementAt(i);%>
  <tr> 
      <td width='80' align='center'><%=tax3.get("DLV_DT")%></td>
      <td width='80' align='center'><%=tax3.get("CONT_DT")%>&nbsp;</td>
    <td width='85' align='center'><%=tax3.get("FIRST_CAR_NO")%></td>
    <td width='85' align='center'><%=tax3.get("CAR_NO2")%></td>
    <td width='85' align='center'><%=tax3.get("CAR_NM")%></td>
      <td width='45' align='center'>3</td>
      <td width='95' align='right'> 
        <input type="text" name="car_fs_amt" value="<%=Util.parseDecimal(String.valueOf(tax3.get("CAR_FS_AMT")))%>" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align='center'>
        <input type="text" name="sur_rate" value="<%=t_db.getSurRate(String.valueOf(tax3.get("DLV_DT")), String.valueOf(tax3.get("CLS_ST")))%>" size="5" class="whitenum">
        %</td>
      <td width='95' align='right'> 
        <input type="text" name="sur_amt" value="" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align='center'>
        <input type="text" name="tax_rate" value="<%=t_db.getTaxRate("특소세", (String)tax3.get("DPM"), (String)tax3.get("DLV_DT"))%>" size="5" class="whitenum">
        %</td>
    <td width='70' align='right'><input type="text" name="spe_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td width='80' align='right'><input type="text" name="edu_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td width='80' align='right'><input type="text" name="tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
  </tr>
  <%	}
	}%>
  <tr> 
      <td width='80' align="center">소계</td>
      <td width='80' align="center">(배기량-3)</td>
    <td width='85' align="center">&nbsp;</td>
    <td width='85'>&nbsp;</td>
    <td width='85'>&nbsp;</td>
      <td width='45'>&nbsp;</td>
      <td width='95' align="right"> 
        <input type="text" name="h_car_fs_amt" value="" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align="right">&nbsp;</td>
      <td width='95' align="right"> 
        <input type="text" name="h_sur_amt" value="" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align="right">&nbsp;</td>
    <td width='70' align="right"><input type="text" name="h_spe_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td width='80' align="right"><input type="text" name="h_edu_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td align="right" width="80"><input type="text" name="h_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
  </tr>
  <tr> 
      <td width='80' align="center">총합계</td>
      <td width='80'>&nbsp;</td>
    <td width='85'>&nbsp;</td>
    <td width='85'>&nbsp;</td>
    <td width='85'>&nbsp;</td>
      <td width='45'>&nbsp;</td>
      <td width='95' align="right"> 
        <input type="text" name="h_car_fs_amt" value="" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align="right">&nbsp;</td>
      <td width='95' align="right"> 
        <input type="text" name="h_sur_amt" value="" size="10" class="whitenum">
        원&nbsp;</td>
      <td width='55' align="right">&nbsp;</td>
    <td width='70' align="right"><input type="text" name="h_spe_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td width='80' align="right"><input type="text" name="h_edu_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
    <td align="right" width="80"><input type="text" name="h_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
  </tr>
</table>
</form>
<script language='javascript'>
<!--
	set_amt();
-->
</script>
</body>
</html>
