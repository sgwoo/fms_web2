<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"5":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	if(save_dt.equals(""))	save_dt = sb_db.getMaxSaveDt("stat_bus");
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");
	
	Vector buss1 = sb_db.getStatBusSearch_20070515("5", brch_id, s_yy, s_mm, "0002");
	int bus_size1 = buss1.size();
	Vector buss2 = sb_db.getStatBusSearch_20070515(gubun, brch_id, s_yy, s_mm, "0001");
	int bus_size2 = buss2.size();
	Vector buss3 = sb_db.getStatBusSearch_20070515(gubun, brch_id, s_yy, s_mm, "0004");
	int bus_size3 = buss3.size();
	
	int tot_cnt[] 	= new int[4];
	int c_cnt[] 	= new int[4];
	int cnt10[] 	= new int[4];
	int cnt20[] 	= new int[4];
	int cnt30[] 	= new int[4];
	int cnt01[] 	= new int[4];
	int cnt02[] 	= new int[4];
	int cnt03[] 	= new int[4];
	int cnt04[] 	= new int[4];
	int cnt05[] 	= new int[4];
	int cnt11[] 	= new int[4];
	int cnt12[] 	= new int[4];
	int cnt13[] 	= new int[4];
	int cnt14[] 	= new int[4];
	int cnt15[] 	= new int[4];
	int cnt21[] 	= new int[4];
	int cnt22[] 	= new int[4];
	int cnt23[] 	= new int[4];
	int cnt24[] 	= new int[4];
	int cnt25[] 	= new int[4];
	int cnt31[] 	= new int[4];
	int cnt32[] 	= new int[4];
	int cnt33[] 	= new int[4];
	int cnt34[] 	= new int[4];
	int cnt35[] 	= new int[4];
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
<script language='javascript'>
<!--

	function stat_search(mode, bus_id2){	
		var fm = document.form1;	
		parent.location.href = "/acar/condition/rent_cond_frame.jsp?dt=3&gubun2=1&ref_dt1=<%=s_yy%>&ref_dt2=<%=s_mm%>&gubun3=1&gubun4="+bus_id2;		
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/index.css">
</head>
<body onLoad="javascript:init()">
<form action="stat_bus_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='bus_size1' value='<%=bus_size1%>'>
<input type='hidden' name='bus_size2' value='<%=bus_size2%>'>
<input type='hidden' name='bus_size3' value='<%=bus_size3%>'>
<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='bus_id2' value=''>
<input type='hidden' name='mode' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1542>
    <tr id='tr_title' style='position:relative;z-index:1'>
	  <td  width='280' id='td_title' style='position:relative;'> <table width="292" border="0" cellspacing="1" cellpadding="1" bgcolor="#000000" height="61">
          <tr align="center" valign="middle" bgcolor="#6784ba"> 
            <td width="70"><font color="#FFFFFF">부서</font></td>
            <td width="20"><font color="#FFFFFF">연번</font></td>
            <td width="52"><font color="#FFFFFF">성명</font></td>
            <td width="80"><font color="#FFFFFF">입사일자</font></td>
            <td width="70"><font color="#FFFFFF">총합계</font></td>
          </tr>
        </table></td>
	<td width='750'>
	    <table width='1250' border="0" cellspacing="1" cellpadding="1" bgcolor="#000000" height="61">
          <tr bgcolor="#6784ba" align="center"> 
            <td class=title colspan="6"><font color="#FFFFFF">합계</font></td>
            <td class=title colspan="6"><font color="#FFFFFF">일반식</font></td>
            <td class=title colspan="6"><font color="#FFFFFF">기본식</font></td>
            <td class=title colspan="6"><font color="#FFFFFF">맞춤식</font></td>
            <td class=title rowspan="2" width="50"><font color="#FFFFFF">업체수</font></td>
          </tr>
          <tr bgcolor="#6784ba" align="center"> 
            <td class=title width="50"><font color="#FFFFFF">신규</font></td>
            <td class=title width="50"><font color="#FFFFFF">대차</font></td>
            <td class=title width="50"><font color="#FFFFFF">증차</font></td>
            <td class=title width="50"><font color="#FFFFFF">연장<br>
              </font></td>
            <td class=title width="50"><font color="#FFFFFF">보유차<br>
              </font></td>
            <td class=title width="50"><font color="#FFFFFF">계</font></td>
            <td class=title width="50"><font color="#FFFFFF">신규</font></td>
            <td class=title width="50"><font color="#FFFFFF">대차</font></td>
            <td class=title width="50"><font color="#FFFFFF">증차</font></td>
            <td class=title width="50"><font color="#FFFFFF">연장<br>
              </font></td>
            <td class=title width="50"><font color="#FFFFFF">보유차<br>
              </font></td>
            <td class=title width="50"><font color="#FFFFFF">계</font></td>
            <td class=title width="50"><font color="#FFFFFF">신규</font></td>
            <td class=title width="50"><font color="#FFFFFF">대차</font></td>
            <td class=title width="50"><font color="#FFFFFF">증차</font></td>
            <td class=title width="50"><font color="#FFFFFF">연장<br>
              </font></td>
            <td class=title width="50"><font color="#FFFFFF">보유차<br>
              </font></td>
            <td class=title width="50"><font color="#FFFFFF">계</font></td>
            <td class=title width="50"><font color="#FFFFFF">신규</font></td>
            <td class=title width="50"><font color="#FFFFFF">대차</font></td>
            <td class=title width="50"><font color="#FFFFFF">증차</font></td>
            <td class=title width="50"><font color="#FFFFFF">연장<br>
              </font></td>
            <td class=title width="50"><font color="#FFFFFF">보유차<br>
              </font></td>
            <td class=title width="50"><font color="#FFFFFF">계</font></td>
          </tr>
        </table>
	</td>
  </tr>  			  
  <tr>
	  <td class='line' width='280' id='td_con' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width='292' bgcolor="#000000">
          <%for (int i = 0 ; i < bus_size1 ; i++){
				Hashtable ht = (Hashtable)buss1.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <%	if(i==0){%>
            <td align="center" width="70"  rowspan="<%=bus_size1%>" height="20"><%=ht.get("NM")%></td>
            <%	}else{}%>
            <td align="center" width="21" height="20"><%=i+1%></td>
            <td align="center" width="50" height="20"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("USER_NM")%></font></a></td>
            <td align="center" width="76" height="20"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
            <td align="center" width="67" height="20"><%=ht.get("TOT_CNT")%></td>
          </tr>
          <%		tot_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));
		  	}%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" colspan="4" height="20">관리팀 소합계</td>
            <td class="is" align="center" height="20" width="67"><%=tot_cnt[0]%></td>
          </tr>
          <%for (int i = 0 ; i < bus_size2 ; i++){
				Hashtable ht = (Hashtable)buss2.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <%	if(i==0){%>
            <td align="center" width="70"  rowspan="<%=bus_size2%>" height="20"><%=ht.get("NM")%></td>
            <%	}else{}%>
            <td align="center" width="21" height="20"><%=i+1%></td>
            <td align="center" width="50" height="20"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("USER_NM")%></font></a></td>
            <td align="center" width="76" height="20"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
            <td align="center" width="67" height="20"><%=ht.get("TOT_CNT")%></td>
          </tr>
          <%		tot_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));
		  	}%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" colspan="4" height="20">영업팀 소합계</td>
            <td class="is" align="center" height="20" width="67"><%=tot_cnt[1]%></td>
          </tr>
          <%for (int i = 0 ; i < bus_size3 ; i++){
				Hashtable ht = (Hashtable)buss3.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <%	if(i==0){%>
            <td align="center" width="70"  rowspan="<%=bus_size3%>" height="20"><%=ht.get("NM")%></td>
            <%	}else{}%>
            <td align="center" width="21" height="20"><%=i+1%></td>
            <td align="center" width="50" height="20"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("USER_NM")%></font></a></td>
            <td align="center" width="76" height="20"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
            <td align="center" width="67" height="20"><%=ht.get("TOT_CNT")%></td>
          </tr>
          <%		tot_cnt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));
		  	}%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" colspan="4" height="20">기타 소합계</td>
            <td class="is" align="center" height="20" width="67"><%=tot_cnt[2]%></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td class="star" align="center" colspan="4" height="20">총합계</td>
            <td class="star" align="center" height="20" width="67"><%=tot_cnt[0]+tot_cnt[1]+tot_cnt[2]%></td>
          </tr>
        </table></td>
	<td class='line' width='750'>
	    <table border="0" cellspacing="1" cellpadding="0" width='1250' bgcolor="#000000">
          <%for (int i = 0 ; i < bus_size1 ; i++){
				Hashtable ht = (Hashtable)buss1.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT01")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT02")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT03")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT04")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT05")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("TOT_CNT")%></td>		
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT11")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT12")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT13")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT14")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT15")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT10")%></td>																		
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT21")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT22")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT23")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT24")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT25")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT20")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT31")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT32")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT33")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT34")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT35")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT30")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("C_CNT")%></td>																																				
          </tr>
          <%		c_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("C_CNT")));
					cnt10[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));
					cnt20[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));
					cnt30[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT30")));
					cnt01[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT01")));
					cnt02[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT02")));
					cnt03[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT03")));
					cnt04[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT04")));
					cnt05[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT05")));
					cnt11[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));
					cnt12[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));
					cnt13[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));
					cnt14[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));
					cnt15[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));
					cnt21[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT21")));
					cnt22[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT22")));
					cnt23[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT23")));
					cnt24[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT24")));
					cnt25[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT25")));
					cnt31[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT31")));
					cnt32[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT32")));
					cnt33[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT33")));
					cnt34[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT34")));
					cnt35[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT35")));
			}%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" height="20" width="50"><%=cnt01[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt02[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt03[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt04[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt05[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=tot_cnt[0]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt11[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt12[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt13[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt14[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt15[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt10[0]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt21[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt22[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt23[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt24[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt25[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt20[0]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt31[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt32[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt33[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt34[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt35[0]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt30[0]%></td>		
            <td class="is" align="center" height="20" width="50"><%=c_cnt[0]%></td>																																				
          </tr>
          <%for (int i = 0 ; i < bus_size2 ; i++){
				Hashtable ht = (Hashtable)buss2.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT01")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT02")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT03")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT04")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT05")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("TOT_CNT")%></td>		
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT11")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT12")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT13")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT14")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT15")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT10")%></td>																		
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT21")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT22")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT23")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT24")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT25")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT20")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT31")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT32")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT33")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT34")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT35")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT30")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("C_CNT")%></td>																																				
          </tr>
          <%		c_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("C_CNT")));
					cnt10[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));
					cnt20[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));
					cnt30[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT30")));
					cnt01[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT01")));
					cnt02[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT02")));
					cnt03[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT03")));
					cnt04[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT04")));
					cnt05[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT05")));
					cnt11[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));
					cnt12[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));
					cnt13[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));
					cnt14[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));
					cnt15[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));
					cnt21[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT21")));
					cnt22[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT22")));
					cnt23[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT23")));
					cnt24[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT24")));
					cnt25[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT25")));
					cnt31[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT31")));
					cnt32[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT32")));
					cnt33[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT33")));
					cnt34[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT34")));
					cnt35[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT35")));
			}%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" height="20" width="50"><%=cnt01[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt02[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt03[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt04[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt05[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=tot_cnt[1]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt11[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt12[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt13[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt14[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt15[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt10[1]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt21[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt22[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt23[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt24[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt25[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt20[1]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt31[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt32[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt33[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt34[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt35[1]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt30[1]%></td>		
            <td class="is" align="center" height="20" width="50"><%=c_cnt[1]%></td>																																				
          </tr>
          <%for (int i = 0 ; i < bus_size3 ; i++){
				Hashtable ht = (Hashtable)buss3.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT01")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT02")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT03")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT04")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT05")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("TOT_CNT")%></td>		
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT11")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT12")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT13")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT14")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT15")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT10")%></td>																		
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT21")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT22")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT23")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT24")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT25")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT20")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT31")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT32")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT33")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT34")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT35")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("CNT30")%></td>
            <td class="is" align="center" height="20" width="50"><%=ht.get("C_CNT")%></td>																																				
          </tr>
          <%		c_cnt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("C_CNT")));
					cnt10[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));
					cnt20[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));
					cnt30[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT30")));
					cnt01[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT01")));
					cnt02[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT02")));
					cnt03[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT03")));
					cnt04[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT04")));
					cnt05[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT05")));
					cnt11[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));
					cnt12[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));
					cnt13[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));
					cnt14[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));
					cnt15[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));
					cnt21[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT21")));
					cnt22[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT22")));
					cnt23[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT23")));
					cnt24[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT24")));
					cnt25[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT25")));
					cnt31[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT31")));
					cnt32[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT32")));
					cnt33[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT33")));
					cnt34[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT34")));
					cnt35[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT35")));
			}%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" height="20" width="50"><%=cnt01[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt02[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt03[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt04[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt05[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=tot_cnt[2]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt11[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt12[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt13[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt14[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt15[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt10[2]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt21[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt22[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt23[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt24[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt25[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt20[2]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt31[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt32[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt33[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt34[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt35[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt30[2]%></td>		
            <td class="is" align="center" height="20" width="50"><%=c_cnt[2]%></td>																																				
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" height="20" width="50"><%=cnt01[0]+cnt01[1]+cnt01[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt02[0]+cnt02[1]+cnt02[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt03[0]+cnt03[1]+cnt03[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt04[0]+cnt04[1]+cnt04[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt05[0]+cnt05[1]+cnt05[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=tot_cnt[0]+tot_cnt[1]+tot_cnt[2]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt11[0]+cnt11[1]+cnt11[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt12[0]+cnt12[1]+cnt12[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt13[0]+cnt13[1]+cnt13[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt14[0]+cnt14[1]+cnt14[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt15[0]+cnt15[1]+cnt15[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt10[0]+cnt10[1]+cnt10[2]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt21[0]+cnt21[1]+cnt21[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt22[0]+cnt22[1]+cnt22[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt23[0]+cnt23[1]+cnt23[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt24[0]+cnt24[1]+cnt24[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt25[0]+cnt25[1]+cnt25[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt20[0]+cnt20[1]+cnt20[2]%></td>		
            <td class="is" align="center" height="20" width="50"><%=cnt31[0]+cnt31[1]+cnt31[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt32[0]+cnt32[1]+cnt32[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt33[0]+cnt33[1]+cnt33[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt34[0]+cnt34[1]+cnt34[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt35[0]+cnt35[1]+cnt35[2]%></td>
            <td class="is" align="center" height="20" width="50"><%=cnt30[0]+cnt30[1]+cnt30[2]%></td>		
            <td class="is" align="center" height="20" width="50"><%=c_cnt[0]+c_cnt[1]+c_cnt[2]%></td>																																				
          </tr>
        </table>
	  </td>
	</tr>
</table>		
</form>
<script language='javascript'>
<!--
//-->
</script>
<%if(gubun.equals("5")){%>* 대여개시된 계약<br><%}%>
* 약정기간이 6개월 이상인 계약<br>
* 연장계약은 연장계약담당자
</body>
</html>
