<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*, acar.admin.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
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
		//소계
/*		for(i=3; i<8; i+=4){
			fm.y2000[i].value = parseDecimal(toInt(parseDigit(fm.y2000[i-3].value)) + toInt(parseDigit(fm.y2000[i-2].value)) + toInt(parseDigit(fm.y2000[i-1].value)));
			fm.y2001[i].value = parseDecimal(toInt(parseDigit(fm.y2001[i-3].value)) + toInt(parseDigit(fm.y2001[i-2].value)) + toInt(parseDigit(fm.y2001[i-1].value)));
			fm.y2002[i].value = parseDecimal(toInt(parseDigit(fm.y2002[i-3].value)) + toInt(parseDigit(fm.y2002[i-2].value)) + toInt(parseDigit(fm.y2002[i-1].value)));
			fm.y2003[i].value = parseDecimal(toInt(parseDigit(fm.y2003[i-3].value)) + toInt(parseDigit(fm.y2003[i-2].value)) + toInt(parseDigit(fm.y2003[i-1].value)));
			fm.y2004[i].value = parseDecimal(toInt(parseDigit(fm.y2004[i-3].value)) + toInt(parseDigit(fm.y2004[i-2].value)) + toInt(parseDigit(fm.y2004[i-1].value)));
			fm.y2005[i].value = parseDecimal(toInt(parseDigit(fm.y2005[i-3].value)) + toInt(parseDigit(fm.y2005[i-2].value)) + toInt(parseDigit(fm.y2005[i-1].value)));

			fm.t2000[i].value = parseDecimal(toInt(parseDigit(fm.t2000[i-3].value)) + toInt(parseDigit(fm.t2000[i-2].value)) + toInt(parseDigit(fm.t2000[i-1].value)));
			fm.t2001[i].value = parseDecimal(toInt(parseDigit(fm.t2001[i-3].value)) + toInt(parseDigit(fm.t2001[i-2].value)) + toInt(parseDigit(fm.t2001[i-1].value)));
			fm.t2002[i].value = parseDecimal(toInt(parseDigit(fm.t2002[i-3].value)) + toInt(parseDigit(fm.t2002[i-2].value)) + toInt(parseDigit(fm.t2002[i-1].value)));
			fm.t2003[i].value = parseDecimal(toInt(parseDigit(fm.t2003[i-3].value)) + toInt(parseDigit(fm.t2003[i-2].value)) + toInt(parseDigit(fm.t2003[i-1].value)));
			fm.t2004[i].value = parseDecimal(toInt(parseDigit(fm.t2004[i-3].value)) + toInt(parseDigit(fm.t2004[i-2].value)) + toInt(parseDigit(fm.t2004[i-1].value)));
			fm.t2005[i].value = parseDecimal(toInt(parseDigit(fm.t2005[i-3].value)) + toInt(parseDigit(fm.t2005[i-2].value)) + toInt(parseDigit(fm.t2005[i-1].value)));
		}*/
		//가로 합계	
		for(i=0; i<2; i++){
			fm.year_hab[i].value = parseDecimal(toInt(parseDigit(fm.y2000[i].value)) + toInt(parseDigit(fm.y2001[i].value)) + toInt(parseDigit(fm.y2002[i].value)) + toInt(parseDigit(fm.y2003[i].value)) + toInt(parseDigit(fm.y2004[i].value)) + toInt(parseDigit(fm.y2005[i].value)));
			fm.tax_hab[i].value = parseDecimal(toInt(parseDigit(fm.t2000[i].value)) + toInt(parseDigit(fm.t2001[i].value)) + toInt(parseDigit(fm.t2002[i].value)) + toInt(parseDigit(fm.t2003[i].value)) + toInt(parseDigit(fm.t2004[i].value)) + toInt(parseDigit(fm.t2005[i].value)));			
//			fm.year_hab[i].value = parseDecimal(toInt(parseDigit(fm.y2000[i].value)) + toInt(parseDigit(fm.y2001[i].value)) + toInt(parseDigit(fm.y2002[i].value)) + toInt(parseDigit(fm.y2003[i].value)));
//			fm.tax_hab[i].value = parseDecimal(toInt(parseDigit(fm.t2000[i].value)) + toInt(parseDigit(fm.t2001[i].value)) + toInt(parseDigit(fm.t2002[i].value)) + toInt(parseDigit(fm.t2003[i].value)));				
		}				
		//총계
		fm.tot_y_hab0.value = parseDecimal(toInt(parseDigit(fm.y2000[0].value)) + toInt(parseDigit(fm.y2000[1].value)));
		fm.tot_y_hab1.value = parseDecimal(toInt(parseDigit(fm.y2001[0].value)) + toInt(parseDigit(fm.y2001[1].value)));
		fm.tot_y_hab2.value = parseDecimal(toInt(parseDigit(fm.y2002[0].value)) + toInt(parseDigit(fm.y2002[1].value)));
		fm.tot_y_hab3.value = parseDecimal(toInt(parseDigit(fm.y2003[0].value)) + toInt(parseDigit(fm.y2003[1].value)));
		fm.tot_y_hab4.value = parseDecimal(toInt(parseDigit(fm.y2004[0].value)) + toInt(parseDigit(fm.y2004[1].value)));
		fm.tot_y_hab5.value = parseDecimal(toInt(parseDigit(fm.y2005[0].value)) + toInt(parseDigit(fm.y2005[1].value)));
		
		fm.tot_t_hab0.value = parseDecimal(toInt(parseDigit(fm.t2000[0].value)) + toInt(parseDigit(fm.t2000[1].value)));
		fm.tot_t_hab1.value = parseDecimal(toInt(parseDigit(fm.t2001[0].value)) + toInt(parseDigit(fm.t2001[1].value)));
		fm.tot_t_hab2.value = parseDecimal(toInt(parseDigit(fm.t2002[0].value)) + toInt(parseDigit(fm.t2002[1].value)));
		fm.tot_t_hab3.value = parseDecimal(toInt(parseDigit(fm.t2003[0].value)) + toInt(parseDigit(fm.t2003[1].value)));
		fm.tot_t_hab4.value = parseDecimal(toInt(parseDigit(fm.t2004[0].value)) + toInt(parseDigit(fm.t2004[1].value)));
		fm.tot_t_hab5.value = parseDecimal(toInt(parseDigit(fm.t2005[0].value)) + toInt(parseDigit(fm.t2005[1].value)));														

		fm.tot_ty_hab.value = parseDecimal(toInt(parseDigit(fm.year_hab[0].value)) + toInt(parseDigit(fm.year_hab[1].value)));
		fm.tot_tt_hab.value = parseDecimal(toInt(parseDigit(fm.tax_hab[0].value)) + toInt(parseDigit(fm.tax_hab[1].value)));		
	}	
//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body><!-- onLoad="javascript:init()"-->
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"1":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String s_est_y = request.getParameter("s_est_y")==null?"":request.getParameter("s_est_y");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	
	
	
	int y2000[] = new int[2];
	int y2001[] = new int[2];
	int y2002[] = new int[2];
	int y2003[] = new int[2];
	int y2004[] = new int[2];
	int y2005[] = new int[2];

	//자동차보유현황
	Vector cars = ad_db.getStatCar();
	int car_size = cars.size();
	for(int i = 0 ; i < car_size ; i++){
		StatCarBean bean = (StatCarBean)cars.elementAt(i);
		if(bean.getUse().equals("영업용") && (bean.getKd() == 1 || bean.getKd() == 2 || bean.getKd() == 3)){
			if(bean.getYear() == 2000)			y2000[0] = y2000[0]+1;
			else if(bean.getYear() == 2001)		y2001[0] = y2001[0]+1;
			else if(bean.getYear() == 2002)		y2002[0] = y2002[0]+1;
			else if(bean.getYear() == 2003)		y2003[0] = y2003[0]+1;
			else if(bean.getYear() == 2004)		y2004[0] = y2004[0]+1;
			else if(bean.getYear() == 2005)		y2005[0] = y2005[0]+1;
		}else if(bean.getUse().equals("자가용") && (bean.getKd() == 1 || bean.getKd() == 2 || bean.getKd() == 3)){
			if(bean.getYear() == 2000)			y2000[1] = y2000[1]+1;
			else if(bean.getYear() == 2001)		y2001[1] = y2001[1]+1;
			else if(bean.getYear() == 2002)		y2002[1] = y2002[1]+1;
			else if(bean.getYear() == 2003)		y2003[1] = y2003[1]+1;
			else if(bean.getYear() == 2004)		y2004[1] = y2004[1]+1;
			else if(bean.getYear() == 2005)		y2005[1] = y2005[1]+1;
		}
	}
%>
<form name='form1' method='post'>
<input type='hidden' name='tax_size' value='<%=car_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=780>
	<tr>		
      <td class='line'> 
        <table width="780" border="0" cellspacing="1" cellpadding="1">
          <tr> 
            <td class=title rowspan="2">구분</td>
            <td class=title colspan="2">2000년식</td>
            <td class=title colspan="2">2001년식</td>
            <td class=title colspan="2">2002년식</td>
            <td class=title colspan="2">2003년식</td>
            <td class=title colspan="2">2004년식</td>
            <td class=title colspan="2">2005년식</td>
            <td class=title colspan="2">합계</td>
          </tr>
          <tr> 
            <td class=title>보유<br>
              대수</td>
            <td class=title>납부<br>
              대수</td>
            <td class=title>보유<br>
              대수</td>
            <td class=title>납부<br>
              대수</td>
            <td class=title>보유<br>
              대수</td>
            <td class=title>납부<br>
              대수</td>
            <td class=title>보유<br>
              대수</td>
            <td class=title>납부<br>
              대수</td>
            <td class=title width="50">보유<br>
              대수</td>
            <td class=title width="50">납부<br>
              대수</td>
            <td class=title width="50">보유<br>
              대수</td>
            <td class=title width="50">납부<br>
              대수</td>
            <td class=title>보유<br>
              대수</td>
            <td class=title>납부<br>
              대수</td>
          </tr>
          <tr> 
            <td align="center">렌트사업용</td>
            <td align="center"> 
              <input type="text" name="y2000" size="3"  class="whitenum" value="<%=y2000[0]%>">
            </td>
            <td align="center"> 
              <input type="text" name="t2000" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("S", "2000", "'1','2','3'")%>">
            </td>
            <td align="center"> 
              <input type="text" name="y2001" size="3"  class="whitenum" value="<%=y2001[0]%>">
            </td>
            <td align="center"> 
              <input type="text" name="t2001" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("S", "2001", "'1','2','3'")%>">
            </td>
            <td align="center"> 
              <input type="text" name="y2002" size="3"  class="whitenum" value="<%=y2002[0]%>">
            </td>
            <td align="center"> 
              <input type="text" name="t2002" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("S", "2002", "'1','2','3'")%>">
            </td>
            <td align="center"> 
              <input type="text" name="y2003" size="3"  class="whitenum" value="<%=y2003[0]%>">
            </td>
            <td align="center"> 
              <input type="text" name="t2003" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("S", "2003", "'1','2','3'")%>">
            </td>
            <td align="center" width="50"> 
              <input type="text" name="y2004" size="3"  class="whitenum" value="<%=y2004[0]%>">
            </td>
            <td align="center" width="50"> 
              <input type="text" name="t2004" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("S", "2004", "'1','2','3'")%>">
            </td>
            <td align="center" width="50"> 
              <input type="text" name="y2005" size="3"  class="whitenum" value="<%=y2005[0]%>">
            </td>
            <td align="center" width="50"> 
              <input type="text" name="t2005" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("S", "2005", "'1','2','3'")%>">
            </td>
            <td align="center"> 
              <input type="text" name="year_hab" size="3"  class="whitenum">
            </td>
            <td align="center"> 
              <input type="text" name="tax_hab" size="3"  class="whitenum">
            </td>
          </tr>
          <tr> 
            <td align="center">리스사업용</td>
            <td align="center"> 
              <input type="text" name="y2000" size="3"  class="whitenum" value="<%=y2000[1]%>">
            </td>
            <td align="center"> 
              <input type="text" name="t2000" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("L", "2000", "'1','2','3'")%>">
            </td>
            <td align="center"> 
              <input type="text" name="y2001" size="3"  class="whitenum" value="<%=y2001[1]%>">
            </td>
            <td align="center"> 
              <input type="text" name="t2001" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("L", "2001", "'1','2','3'")%>">
            </td>
            <td align="center"> 
              <input type="text" name="y2002" size="3"  class="whitenum" value="<%=y2002[1]%>">
            </td>
            <td align="center"> 
              <input type="text" name="t2002" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("L", "2002", "'1','2','3'")%>">
            </td>
            <td align="center"> 
              <input type="text" name="y2003" size="3"  class="whitenum" value="<%=y2003[1]%>">
            </td>
            <td align="center"> 
              <input type="text" name="t2003" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("L", "2003", "'1','2','3'")%>">
            </td>
            <td align="center" width="50"> 
              <input type="text" name="y2004" size="3"  class="whitenum" value="<%=y2004[1]%>">
            </td>
            <td align="center" width="50"> 
              <input type="text" name="t2004" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("L", "2004", "'1','2','3'")%>">
            </td>
            <td align="center" width="50"> 
              <input type="text" name="y2005" size="3"  class="whitenum" value="<%=y2005[1]%>">
            </td>
            <td align="center" width="50"> 
              <input type="text" name="t2005" size="3"  class="whitenum" value="<%=t_db.getTaxPayCarCnt("L", "2005", "'1','2','3'")%>">
            </td>
            <td align="center"> 
              <input type="text" name="year_hab" size="3"  class="whitenum">
            </td>
            <td align="center"> 
              <input type="text" name="tax_hab" size="3"  class="whitenum">
            </td>
          </tr>
          <tr> 
            <td class="star" align="center">합계</td>
            <td class="star" align="center"> 
              <input type="text" name="tot_y_hab0" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center"> 
              <input type="text" name="tot_t_hab0" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center"> 
              <input type="text" name="tot_y_hab1" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center"> 
              <input type="text" name="tot_t_hab1" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center"> 
              <input type="text" name="tot_y_hab2" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center"> 
              <input type="text" name="tot_t_hab2" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center"> 
              <input type="text" name="tot_y_hab3" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center"> 
              <input type="text" name="tot_t_hab3" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center" width="50"> 
              <input type="text" name="tot_y_hab4" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center" width="50"> 
              <input type="text" name="tot_t_hab4" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center" width="50"> 
              <input type="text" name="tot_y_hab5" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center" width="50"> 
              <input type="text" name="tot_t_hab5" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center"> 
              <input type="text" name="tot_ty_hab" size="3"  class="whitenum" readonly>
            </td>
            <td class="star" align="center"> 
              <input type="text" name="tot_tt_hab" size="3"  class="whitenum" readonly>
            </td>
          </tr>
        </table>
      </td>		
	</tr>
</table>
</form>
<script language='javascript'>
<!--
	set_amt();
//-->
</script>
</body>
</html>
