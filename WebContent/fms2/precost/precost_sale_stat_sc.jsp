<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

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
	long sum31 = 0;
	long sum32 = 0;
	long sum33 = 0;
	long sum34 = 0;
	long sum35 = 0;
	long sum36 = 0;
	long sum37 = 0;
	long sum38 = 0;
	long sum39 = 0;
	long sum40 = 0;
	
	//대여료 정상발행분
	Vector vt1 = ad_db.getPrecostSaleFeeList(gubun1, gubun2);
	int vt1_size = vt1.size();
	
	for(int i = 0 ; i < vt1_size ; i++){
		Hashtable ht = (Hashtable)vt1.elementAt(i);
		if(String.valueOf(ht.get("CAR_USE")).equals("1")){
			sum1  = Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum2  = Util.parseLong(String.valueOf(ht.get("AMT2")));
		}else if(String.valueOf(ht.get("CAR_USE")).equals("2")){
			sum3  = Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum4  = Util.parseLong(String.valueOf(ht.get("AMT2")));
		}
	}
	
	//대여료 연체해소로 미발행분 일괄발행 - 전월
	Vector vt2 = ad_db.getPrecostSaleFeeList2(gubun1, gubun2, "last month");
	int vt2_size = vt2.size();
	
	for(int i = 0 ; i < vt2_size ; i++){
		Hashtable ht = (Hashtable)vt2.elementAt(i);
		if(String.valueOf(ht.get("CAR_USE")).equals("1")){
			sum5  = Util.parseLong(String.valueOf(ht.get("AMT")));
		}else if(String.valueOf(ht.get("CAR_USE")).equals("2")){
			sum7  = Util.parseLong(String.valueOf(ht.get("AMT")));
		}
	}
	
	//대여료 연체해소로 미발행분 일괄발행 - 당월
	Vector vt3 = ad_db.getPrecostSaleFeeList2(gubun1, gubun2, "");
	int vt3_size = vt3.size();
	
	for(int i = 0 ; i < vt3_size ; i++){
		Hashtable ht = (Hashtable)vt3.elementAt(i);
		if(String.valueOf(ht.get("CAR_USE")).equals("1")){
			sum6  = Util.parseLong(String.valueOf(ht.get("AMT")));
		}else if(String.valueOf(ht.get("CAR_USE")).equals("2")){
			sum8  = Util.parseLong(String.valueOf(ht.get("AMT")));
		}
	}	
	
	//대여료 연체발행중지로 미발행분 - 전월
	Vector vt4 = ad_db.getPrecostSaleFeeList3(gubun1, gubun2, "last month");
	int vt4_size = vt4.size();
	
	for(int i = 0 ; i < vt4_size ; i++){
		Hashtable ht = (Hashtable)vt4.elementAt(i);
		if(String.valueOf(ht.get("CAR_USE")).equals("1")){
			sum9  = Util.parseLong(String.valueOf(ht.get("AMT")));
		}else if(String.valueOf(ht.get("CAR_USE")).equals("2")){
			sum11  = Util.parseLong(String.valueOf(ht.get("AMT")));
		}
	}
	
	//대여료 연체발행중지로 미발행분 - 당월
	Vector vt5 = ad_db.getPrecostSaleFeeList3(gubun1, gubun2, "");
	int vt5_size = vt5.size();
	
	for(int i = 0 ; i < vt5_size ; i++){
		Hashtable ht = (Hashtable)vt5.elementAt(i);
		if(String.valueOf(ht.get("CAR_USE")).equals("1")){
			sum10  = Util.parseLong(String.valueOf(ht.get("AMT")));
		}else if(String.valueOf(ht.get("CAR_USE")).equals("2")){
			sum12  = Util.parseLong(String.valueOf(ht.get("AMT")));
		}
	}
	
	//선수금 정상발행분
	Vector vt6 = ad_db.getPrecostSaleFeeList4(gubun1, gubun2);
	int vt6_size = vt6.size();
	
	for(int i = 0 ; i < vt6_size ; i++){
		Hashtable ht = (Hashtable)vt6.elementAt(i);
		if(String.valueOf(ht.get("CAR_USE")).equals("1")){
			sum13  = Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum14  = Util.parseLong(String.valueOf(ht.get("AMT2")));
		}else if(String.valueOf(ht.get("CAR_USE")).equals("2")){
			sum15  = Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum16  = Util.parseLong(String.valueOf(ht.get("AMT2")));
		}
	}
	
	//기타매출 정상발행분
	Vector vt7 = ad_db.getPrecostSaleFeeList5(gubun1, gubun2);
	int vt7_size = vt7.size();
	
	for(int i = 0 ; i < vt7_size ; i++){
		Hashtable ht = (Hashtable)vt7.elementAt(i);
		if(String.valueOf(ht.get("CAR_USE")).equals("1")){//영업용
			sum17  = Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum18  = Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum21  = Util.parseLong(String.valueOf(ht.get("AMT1_1")));
			sum22  = Util.parseLong(String.valueOf(ht.get("AMT2_1")));
			sum25  = Util.parseLong(String.valueOf(ht.get("AMT1_2")));
			sum26  = Util.parseLong(String.valueOf(ht.get("AMT2_2")));
			sum29  = Util.parseLong(String.valueOf(ht.get("AMT1_3")));
			sum30  = Util.parseLong(String.valueOf(ht.get("AMT2_3")));
			sum33  = Util.parseLong(String.valueOf(ht.get("AMT1_4")));
			sum34  = Util.parseLong(String.valueOf(ht.get("AMT2_4")));
			sum37  = Util.parseLong(String.valueOf(ht.get("AMT1_5")));
			sum38  = Util.parseLong(String.valueOf(ht.get("AMT2_5")));
		}else if(String.valueOf(ht.get("CAR_USE")).equals("2")){//자가용
			sum19  = Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum20  = Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum23  = Util.parseLong(String.valueOf(ht.get("AMT1_1")));
			sum24  = Util.parseLong(String.valueOf(ht.get("AMT2_1")));
			sum27  = Util.parseLong(String.valueOf(ht.get("AMT1_2")));
			sum28  = Util.parseLong(String.valueOf(ht.get("AMT2_2")));
			sum31  = Util.parseLong(String.valueOf(ht.get("AMT1_3")));
			sum32  = Util.parseLong(String.valueOf(ht.get("AMT2_3")));
			sum35  = Util.parseLong(String.valueOf(ht.get("AMT1_4")));
			sum36  = Util.parseLong(String.valueOf(ht.get("AMT2_4")));
			sum39  = Util.parseLong(String.valueOf(ht.get("AMT1_5")));
			sum40  = Util.parseLong(String.valueOf(ht.get("AMT2_5")));
		}
	}
	
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
<input type='hidden' name='go_url' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>[렌트] 전월대비 매출변동 분석</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>구분</td>
            <td width="30%" class='title'>내용</td>
            <td width="20%" class='title'>전월</td>
            <td width='20%' class='title'>기준월</td>
            <td width="20%" class='title'>차액</td>
          </tr>
          <tr> 
            <td rowspan="3">대여료</td>
            <td>정상발행분</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum1)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum2)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum2-sum1)%></td>
          </tr>
          <tr> 
            <td>연체해소로 미발행분 일괄발행 </td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum5)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum6)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum6-sum5)%></td>
          </tr>
          <tr> 
            <td>연체발행중지로 미발행분 </td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum9)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum10)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum10-sum9)%></td>
          </tr>
          <tr> 
            <td>선수금</td>
            <td>발행분(개시대여료,선납금,승계수수료)</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum13)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum14)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum14-sum13)%></td>
          </tr>
          <tr> 
            <td rowspan="5">기타</td>
            <td>차량면책금</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum21)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum22)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum22-sum21)%></td>
          </tr>
          <tr> 
            <td>대차료</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum25)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum26)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum26-sum25)%></td>
          </tr>		  
          <tr> 
            <td>단기대여</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum29)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum30)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum30-sum29)%></td>
          </tr>		  
          <tr> 
            <td>업무지원</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum33)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum34)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum34-sum33)%></td>
          </tr>		  
          <tr> 
            <td>해지(미납대여료,손해배상금,위약금)</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum37)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum38)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum38-sum37)%></td>
          </tr>		  
          <tr> 
            <td colspan="2" class=title style='font-size:8pt'>계</td>
            <td style='text-align:right; font-size=8pt' class=title>&nbsp;<%=AddUtil.parseDecimalLong(sum1+sum5+sum9+sum13+sum21+sum25+sum29+sum33+sum37)%></td>
            <td style='text-align:right; font-size=8pt' class=title>&nbsp;<%=AddUtil.parseDecimalLong(sum2+sum6+sum10+sum14+sum22+sum26+sum30+sum34+sum38)%></td>
            <td class=title style='text-align:right; font-size=8pt'><%=AddUtil.parseDecimalLong((sum2+sum6+sum10+sum14+sum22+sum26+sum30+sum34+sum38)-(sum1+sum5+sum9+sum13+sum21+sum25+sum29+sum33+sum37))%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td></td>
    </tr>	
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>[리스] 전월대비 매출변동 분석</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>구분</td>
            <td width="30%" class='title'>내용</td>
            <td width="20%" class='title'>전월</td>
            <td width='20%' class='title'>기준월</td>
            <td width="20%" class='title'>차액</td>
          </tr>
          <tr> 
            <td rowspan="3">대여료</td>
            <td>정상발행분</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum3)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum4)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum4-sum3)%></td>
          </tr>
          <tr> 
            <td>연체해소로 미발행분 일괄발행 </td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum7)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum8)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum8-sum7)%></td>
          </tr>
          <tr> 
            <td>연체발행중지로 미발행분 </td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum11)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum12)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum12-sum11)%></td>
          </tr>
          <tr> 
            <td>선수금</td>
            <td>발행분(개시대여료,선납금,승계수수료)</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum15)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum16)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum16-sum15)%></td>
          </tr>
          <tr> 
            <td rowspan="5">기타</td>
            <td>차량면책금</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum23)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum24)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum24-sum23)%></td>
          </tr>
          <tr> 
            <td>대차료</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum27)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum28)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum28-sum27)%></td>
          </tr>		  
          <tr> 
            <td>단기대여</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum31)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum32)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum32-sum31)%></td>
          </tr>		  
          <tr> 
            <td>업무지원</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum35)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum36)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum36-sum35)%></td>
          </tr>		  
          <tr> 
            <td>해지(미납대여료,손해배상금,위약금)</td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum39)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum40)%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(sum40-sum39)%></td>
          </tr>		  
          <tr> 
            <td colspan="2" class=title style='font-size:8pt'>계</td>
            <td style='text-align:right; font-size=8pt' class=title>&nbsp;<%=AddUtil.parseDecimalLong(sum3+sum7+sum11+sum15+sum23+sum27+sum31+sum35+sum39)%></td>
            <td style='text-align:right; font-size=8pt' class=title>&nbsp;<%=AddUtil.parseDecimalLong(sum4+sum8+sum12+sum16+sum24+sum28+sum32+sum36+sum40)%></td>
            <td class=title style='text-align:right; font-size=8pt'><%=AddUtil.parseDecimalLong((sum4+sum8+sum12+sum16+sum24+sum28+sum32+sum36+sum40)-(sum3+sum7+sum11+sum15+sum23+sum27+sum31+sum35+sum39))%></td>
          </tr>
        </table>
      </td>
    </tr>	
  </table>
</form>
</body>
</html>
