<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
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
	
	function set_amt(){
		var fm = document.form1;	
		var tax_size = toInt(fm.tax_size.value);	
		for(i=0; i<tax_size ; i++){
			if(tax_size == 1){
				if(toInt(fm.tax_come_dt.value) > 20081218 && toInt(fm.tax_come_dt.value) < 20090701){
					fm.tax_rate.value = parseFloat(parseDigit(fm.tax_rate.value))*0.7;
				}
				fm.sur_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value))*(parseFloat(parseDigit(fm.sur_rate.value))/100));
				fm.spe_tax_amt.value = parseDecimal(toInt(parseDigit(fm.sur_amt.value))*(parseFloat(parseDigit(fm.tax_rate.value))/100));	//th_rnd()
				fm.edu_tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))*(30/100));										//th_rnd()
				fm.tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))+toInt(parseDigit(fm.edu_tax_amt.value)));		
				fm.tot_tax_amt.value = fm.tax_amt.value;
			}else{
				if(toInt(fm.tax_come_dt[i].value) > 20081218 && toInt(fm.tax_come_dt[i].value) < 20090701){
					fm.tax_rate[i].value = parseFloat(parseDigit(fm.tax_rate[i].value))*0.7;
				}
				fm.sur_amt[i].value = parseDecimal(toInt(parseDigit(fm.car_fs_amt[i].value))*(parseFloat(parseDigit(fm.sur_rate[i].value))/100));
				fm.spe_tax_amt[i].value = parseDecimal(toInt(parseDigit(fm.sur_amt[i].value))*(parseFloat(parseDigit(fm.tax_rate[i].value))/100));
				fm.edu_tax_amt[i].value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt[i].value))*(30/100));				
				fm.tax_amt[i].value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt[i].value))+toInt(parseDigit(fm.edu_tax_amt[i].value)));					
				fm.tot_tax_amt.value = parseDecimal(toInt(parseDigit(fm.tot_tax_amt.value))+toInt(parseDigit(fm.tax_amt[i].value)));	
			}			
		}
	}
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"1":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int total_su = 0;
	long total_amt = 0;
	
	
	
	Vector taxs = t_db.getTaxEstList5(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, est_mon);
	int tax_size = taxs.size();
%>
<form name='form1' method='post'>
<input type='hidden' name='tax_size' value='<%=tax_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1780>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='380' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='380'>
				<tr>
					<td width='30' class='title' style='height:44'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
					<td width='30' class='title'>연번</td>
					<td width='100' class='title'>계약번호</td>
					<td width='120' class='title'>상호</td>
					<td width='100' class='title'>차량번호</td>
				</tr>
			</table>
		</td>
		<td class='line' width='1400'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='8%' class='title' style='height:44'>차명</td>
                    <td width='5%' class='title'>대여구분</td>			
                    <td width='6%' class='title'>출고일</td>
                    <td width='6%' class='title'>신차<br>대여개시일</td>
                    <td width='6%' class='title'>해지일자</td>			
                    <td width='6%' class='title'>명의이전일</td>	
                    <td width='6%' class='title'>납부사유<br>발생일자</td>											
                    <td width='5%' class='title'>배기량</td>
                    <td width='6%' class='title'>면세구입가</td>
                    <td width='5%' class='title'>잔가율</td>
                    <td width='6%' class='title'>잔존가</td>
                    <td width='5%' class='title'>개별소비세율</td>
                    <td width='6%' class='title'>개별소비세</td>
                    <td width='6%' class='title'>교육세</td>
                    <td width='7%' class='title'>개별소비세 합계</td>
                    <td width='6%' class='title'>지출예정일</td>
                    <td width='5%' class='title'>출금일자</td>			
                </tr>
            </table>
		</td>
	</tr>
<%	if(tax_size > 0){%>
	<tr>
		<td class='line' width='380' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='380'>
              <%for(int i = 0 ; i < tax_size ; i++){
    				Hashtable tax = (Hashtable)taxs.elementAt(i);%>
                <tr> 
					<td width='30' align='center'><input type="checkbox" name="ch_l_cd" value="<%=i%>">
					  <input type='hidden' name='tax_st' value='<%=tax.get("TAX_ST")%>'>
					  <input type='hidden' name='rent_mng_id' value='<%=tax.get("RENT_MNG_ID")%>'>
					  <input type='hidden' name='rent_l_cd' value='<%=tax.get("RENT_L_CD")%>'>
					  <input type='hidden' name='car_mng_id' value='<%=tax.get("CAR_MNG_ID")%>'>
					</td>				
                    <td width='30' align='center'><%=i+1%></td>
                    <td width='99' align='center'><a href="javascript:parent.view_tax2('<%=tax.get("TAX_ST")%>','<%=tax.get("RENT_MNG_ID")%>', '<%=tax.get("RENT_L_CD")%>', '<%=tax.get("CAR_MNG_ID")%>', '', '<%=tax.get("RENT_MON")%>', '<%=tax.get("CLS_ST")%>','<%=tax.get("RENT_12MON")%>','<%=tax.get("DLV_MON")%>')" onMouseOver="window.status=''; return true"><%=tax.get("RENT_L_CD")%></a></td>
                    <td width='119' align='center'><span title='<%=tax.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(tax.get("FIRM_NM")), 8)%></span></td>
                    <td width='100' align='center'><%=tax.get("CAR_NO")%></td>
                </tr>
                <%}%>
                <tr> 
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>					
                    <td class='title'>&nbsp;</td>
                    <td class='title' align='center'>합계</td>
                    <td class='title'>&nbsp;</td>
                </tr>
            </table>
        </td>
        <td class='line' width='1400'>    			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < tax_size ; i++){
    				Hashtable tax = (Hashtable)taxs.elementAt(i);
    				String reg_yn 		= String.valueOf(tax.get("REG_YN"));
    				String tax_come_dt 	= String.valueOf(tax.get("RENT_12MON"));
					String dlv_year 	= "";
					String migr_year 	= "";
					String cls_st 		= String.valueOf(tax.get("CLS_ST"));
					if(!String.valueOf(tax.get("DLV_DT")).equals("")) 		dlv_year 	= String.valueOf(tax.get("DLV_DT")).substring(0,4);
					if(String.valueOf(tax.get("MIGR_DT")).length() > 4) 	migr_year 	= String.valueOf(tax.get("MIGR_DT")).substring(0,4);
    				%>
                <tr> 
                    <td width='8%' align='center'><span title='<%=tax.get("CAR_NM")%> <%=tax.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(tax.get("CAR_NM"))+" "+String.valueOf(tax.get("CAR_NAME")), 8)%></span></td>
                    <td width='5%' align='center'><%=tax.get("TAX_ST")%></td>
                    <td width='6%' align='center'><%=tax.get("DLV_DT")%></td>			
                    <td width='6%' align='center'><%=tax.get("RENT_START_DT")%></td>
                    <td width='6%' align='center'><%=tax.get("CLS_DT")%></td>			
                    <td width='6%' align='center'><%=tax.get("MIGR_DT")%></td>						
                    <td width='6%' align='center'><%=tax_come_dt%><input type='hidden' name='tax_come_dt' value='<%=AddUtil.replace(tax_come_dt,"-","")%>'></td>									
                    <td width='5%' align='center'><%=tax.get("DPM")%>CC</td>
                    <td width='6%' align='right'><input type="text" name="car_fs_amt" value="<%=AddUtil.parseDecimal(String.valueOf(tax.get("CAR_FS_AMT")))%>" size="9" class="whitenum">원&nbsp;</td>
                    <td width='5%' align='center'><input type="text" name="sur_rate" value="<%=t_db.getSurRate200812(String.valueOf(tax.get("DLV_MON")))%>" size="4" class="whitenum">%&nbsp;</td>
                    <td width='6%' align='right'><input type="text" name="sur_amt" value="" size="9" class="whitenum">원&nbsp;</td>
                    <td width='5%' align='center'><input type="text" name="tax_rate" value="<%=t_db.getTaxRate("특소세", String.valueOf(tax.get("DPM")), String.valueOf(tax.get("DLV_DT")))%>" size="4" class="whitenum">%&nbsp;</td>
                    <td width='6%' align='right'><input type="text" name="spe_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
                    <td width='6%' align='right'><input type="text" name="edu_tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
                    <td width='7%' align='right'><input type="text" name="tax_amt" value="" size="9" class="whitenum">원&nbsp;</td>
                    <td width='6%' align='center'>-</td>
                    <td width='5%' align='center'>-</td>			
                </tr>
    		    <%}%>
                <tr> 
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title' style='text-align:right'><input type="text" name="tot_tax_amt" value="<%=tax_size%>" size="10" class="num"> 원&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                </tr>
            </table>
		</td>
<%	}else{%>
	<tr>
		<td class='line' width='380' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='380'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='1400'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>
<script language='javascript'>
<!--
	set_amt();
//-->
</script>
</body>
</html>
