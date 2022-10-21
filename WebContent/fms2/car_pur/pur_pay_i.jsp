<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String trf_st 	= request.getParameter("trf_st")==null?"":request.getParameter("trf_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = d_db.getCarPurPayList(trf_st);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt16 = 0;
	
	int count = 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//영업사원보기
	function view_car_office(car_off_id){
		var fm = document.form1;
		window.open("view_car_office.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/car_pur/pur_pay_i.jsp&cmd=view&car_off_id="+car_off_id, "VIEW_CAR_OFF", "left=50, top=50, width=850, height=200, resizable=yes, scrollbars=yes, status=yes");
	}
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}			
		
	function save(){
		var fm = document.form1;

		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("지출할 계약을 선택하세요.");
			return;
		}	
				
		if(confirm('처리하시겠습니까?')){	
			fm.action='pur_pay_i_a.jsp';		
//			fm.target='i_no';
			fm.submit();
		}									
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='trf_st' 	value='<%=trf_st%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=980>
    <tr>
      <td>&lt; 차량대금 지출처리 &gt; </td>
    </tr>  
    <tr>
      <td></td>
    </tr>  
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  	
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td width='30' class='title'>연번</td>
			<!-- <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td> -->			
		    <td width='100' class='title'>계출번호</td>
		    <td width="90" class='title'>고객</td>
		    <td width="90" class='title'>차종</td>					
       		<td width='100' class='title'>지출처</td>
			<td width='90' class='title'>연락처</td>
			<td width="60" class='title'>구분</td>
			<td width="60" class='title'>지급수단</td>
		    <td width="90" class='title'>종류</td>				  
			<td width="120" class='title'>번호</td>
       		<td width='60' class='title'>최초영업</td>
       		<td width="90" class='title'>금액</td>															
		  </tr>		
		  <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					if(trf_st.equals("후불카드") && String.valueOf(ht.get("TRF_ST")).equals("포인트")) continue;
					
					count++;
		  %>
		  <tr>
			<td align='center'><%=count%></td>
			<!-- <td align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_MNG_ID")%><%=ht.get("RENT_L_CD")%><%=ht.get("GUBUN")%>"></td> -->			
		    <td align='center'><%=ht.get("RPT_NO")%></td>
		    <td align='center'><%=ht.get("FIRM_NM")%><!-- <span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span> --></td>
       		<td align='center'><%=ht.get("CAR_NM")%><!-- <span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span> --></td>					
       		<td align='center'><a href="javascript:view_car_office('<%=ht.get("CAR_OFF_ID")%>');"><font color="#CCCCCC"><%=c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")),"CAR_COM")%></font><br><%=ht.get("DLV_BRCH")%><!-- <span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 6)%></span> --></a></td>
			<td align='center'><%=ht.get("CAR_OFF_TEL")%><%//=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>
			<td align='center'><%=ht.get("TRF_ST")%></td>		
			<td align='center'>
			<%if(String.valueOf(ht.get("GUBUN")).equals("0")){ %>계약금
			<%}else if(String.valueOf(ht.get("GUBUN")).equals("5")){ %>임시운행보험료
			<%}else{ %>대금<%} %>			
			</td>			
			<td align='center'><%=ht.get("CARD_KIND")%><%if(String.valueOf(ht.get("CARD_KIND")).equals("")){%><%=ht.get("BANK")%><%}%></td>
			<td align='center'><%=ht.get("CARDNO")%><%if(String.valueOf(ht.get("CARDNO")).equals("")){%><%=ht.get("ACC_NO")%><%}%></td>						
		    <td align='center'><%=c_db.getNameById(String.valueOf(ht.get("BUS_ID")),"USER")%></td>
		    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%></td>					
		  </tr>
		  <%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("TRF_AMT")));
		 		}%>
		  <tr>
		    <td colspan="8" class=title>합계</td>		    		
			<td class='title'>지출일자</td>									
			<td class='title'><input type='text' size='11' name='pur_pay_dt' maxlength='10' class='text' value='<%=AddUtil.getDate()%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>									
			<td class='title'>&nbsp;</td>
			<td class='title_num'><%=Util.parseDecimal(total_amt1)%></td>												
		  </tr>
		</table>
	  </td>
    </tr>
	<%if(!trf_st.equals("현금")){%>  		    	
    <tr>
      <td>&nbsp;<카드별 집계></td>
    </tr>  
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  	
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td width='30' class='title'>연번</td>
			<td width="100" class='title'>구분</td>
			<td width="130" class='title'>종류</td>				  			
			<td width="300" class='title'>번호</td>
			<td width="150" class='title'>만기일자</td>			
		    <td width="270" class='title'>금액</td>											
		  </tr>		
		  <%	total_amt1 = 0;
			  	Vector vt2 = d_db.getCarPurPayStat(trf_st);
				int vt_size2 = vt2.size();
		  		for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vt2.elementAt(i);
		  %>
		  <tr>
			<td align='center'><%=i+1%></td>
			<td align='center'><%=ht.get("CARD_PAID")%></td>
			<td align='center'><%=ht.get("CARD_KIND")%></td>			
			<td align='center'><%=ht.get("CARDNO")%></td>				
			<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CARD_EDATE")))%></td>								
			<td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("TRF_AMT")))%></td>
		  </tr>
		  <%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("TRF_AMT")));
		 		}%>
		  <tr>
		    <td colspan="5" class=title>합계</td>
		    <td class='title_num'><%=AddUtil.parseDecimalLong(total_amt1)%></td>		
		  </tr>
		</table>
	  </td>
    </tr>  	
	<%}%>	    		
	<tr>
		<td align="right">
		  <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출금담당",user_id) || nm_db.getWorkAuthUser("입금담당",user_id)){%> 
		  <!-- <a href="javascript:save();" onMouseOver="window.status=''; return true">지출처리</a>&nbsp;&nbsp; -->
		  <%}%>
		  <a href="javascript:print();" onMouseOver="window.status=''; return true">인쇄</a><font color="#666666">(가로출력)</font>&nbsp;&nbsp;
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true">닫기</a>
		</td>	
	</tr>				  
	<tr>
		<td>
		  * 지출처리는 출금관리에서 합니다. 자동차영업소에 카드번호를 알려주는 업무에 참고하세요
		</td>	
	</tr>				
  </table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
