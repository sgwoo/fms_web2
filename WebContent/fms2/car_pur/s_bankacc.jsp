<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.bill_mng.*, card.*, acar.cont.*"%>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String st 		= request.getParameter("st")==null?"":request.getParameter("st");
	String value 		= request.getParameter("value")==null?"":request.getParameter("value");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String emp_id		= request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String car_off_id	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	if(car_off_id.equals("")){
		System.out.println("[촐고기안 게좌보기에서 car_off_id가 없습니다.]"+rent_l_cd+""+t_wd);
	}else{
		//출고영업소 정보
		co_bean = cod.getCarOffBean(car_off_id);
	}
	
	
	if(t_wd.equals("") && !value.equals("")) t_wd = value;
	
	
	//출고문서 등록 계좌 최근사용분
	Vector vt3 = d_db.getCarPurBrchAccList3(car_off_id);
	int vt_size3 = vt3.size();
	
	//기타계좌리스트
	Vector vt2 = c_db.getBankAccList("car_off_id", car_off_id, "Y");
	int vt_size2 = vt2.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function Disp(bank, acc_no, acc_nm, acc_st){
		var fm = document.form1;
		<%if(st.equals("DLV") && go_url.equals("/fms2/lc_rent/lc_b_s.jsp")){%>
		opener.form1.con_bank.value = bank;
		opener.form1.con_acc_no.value = acc_no;
		opener.form1.con_acc_nm.value = acc_nm;			
		<%}else{%>
		opener.form1.card_kind<%=idx%>.value = bank;
		opener.form1.cardno<%=idx%>.value 	= acc_no;
		opener.form1.trf_cont<%=idx%>.value = acc_nm;	
		opener.form1.acc_st<%=idx%>.value = acc_st;			
		opener.form1.trf_cont<%=idx%>.focus();	
		<%}%>
		self.close();
	}
	
	//영업소계좌관리
	function BankAccMng(){
		var SUBWIN="/acar/car_office/car_office_bank.jsp?car_off_id=<%=car_off_id%>&car_off_nm=<%=co_bean.getCar_off_nm()%>&car_comp_id=<%=co_bean.getCar_comp_id()%>&car_comp_nm=<%=co_bean.getCar_comp_nm()%>";	
		window.open(SUBWIN, "OfficeBank", "left=100, top=100, width=820, height=500, resizable=yes, scrollbars=yes, status=yes");
	}	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_bankacc.jsp'>
<input type='hidden' name='st' value='<%=st%>'>    
<input type='hidden' name='value' value='<%=value%>'>      
<input type="hidden" name="idx" value="<%=idx%>">
<input type='hidden' name='go_url' value='<%=go_url%>'> 
<input type='hidden' name='emp_id' value='<%=emp_id%>'> 
<input type='hidden' name='car_off_id' value='<%=car_off_id%>'> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<!--
    <tr> 
        <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow_cgyus.gif>
        <input type="text" name="t_wd" value="<%=t_wd%>" size="30" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		&nbsp;
		<a href="javascript:search();" class="btn"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
        </td>
    </tr>	
-->    
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고영업소 <font color='red'>대표계좌</font> 정보</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="4%">연번</td>
                    <!--<td class=title width="8%">구분</td>-->
                    <td class=title width="13%">자동차사</td>										
                    <td class=title width="18%">영업소명</td>										
                    <td class=title width="10%">금융사</td>
                    <td class=title width="22%">계좌번호</td>
                    <td class=title width="34%">예금주</td>
                    <!--<td class=title width="10%">최종사용일</td>-->
                </tr>
                <tr align="center">
                    <td>1</td>
                    <!--<td>영업소</td>-->
                    <td><%=co_bean.getCar_comp_nm()%></td>		  		  										
                    <td><%=co_bean.getCar_off_nm()%></td>		  		  										
                    <td><%=co_bean.getBank()%></td>		  		  
                    <td><a href="javascript:Disp('<%=co_bean.getBank()%>','<%=co_bean.getAcc_no()%>','<%=co_bean.getAcc_nm()%>','1')" onMouseOver="window.status=''; return true"><%=co_bean.getAcc_no()%></a></td>
                    <td><%=co_bean.getAcc_nm()%></td>
                    <!--<td>-</td>-->
                </tr>	
            </table>
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고영업소 <font color='red'>기타계좌</font> 정보</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="4%">연번</td>
                    <td class=title width="13%">자동차사</td>										
                    <td class=title width="18%">영업소명</td>										
                    <td class=title width="10%">금융사</td>
					<td class=title width="8%">계좌구분</td>
                    <td class=title width="18%">계좌번호</td>
                    <td class=title width="20%">예금주</td>
                    <td class=title width="9%">최종수정일</td>
                </tr>
				<%	for (int i = 0 ; i < vt_size2 ; i++){
    					Hashtable ht = (Hashtable)vt2.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=co_bean.getCar_comp_nm()%></td>		  		  										
                    <td><%=co_bean.getCar_off_nm()%></td>		  
                    <td><%=ht.get("BANK_NM")%></td>		  		  							  										
                    <td><%=ht.get("ACC_ST_NM")%></td>		  		  
                    <td><a href="javascript:Disp('<%=ht.get("BANK_NM")%>','<%=ht.get("ACC_NO")%>','<%=ht.get("ACC_NM")%>','<%=ht.get("ACC_ST")%>')" onMouseOver="window.status=''; return true"><%=ht.get("ACC_NO")%></a></td>
                    <td><%=ht.get("ACC_NM")%></td>
                    <td><%=ht.get("UPDATE_DT")%><%if(String.valueOf(ht.get("UPDATE_DT")).equals("")){%><%=ht.get("REG_DT")%><%}%></td>
                </tr>	
				<%	}%>
				<%	if(vt_size2==0){%>
				<tr>
					<td colspan='8' align="center">데이타가 없습니다.</td>
				</tr>
				<%	}%>
            </table>
	    </td>
    </tr>	
    <tr>
        <td align="right"><a href="javascript:BankAccMng()" onMouseOver="window.status=''; return true" title='대표계좌 수정 및 기타계좌를 등록,수정,미사용 처리할 수 있습니다.'><img src=/acar/images/center/button_acc_yus.gif  align="absmiddle" border="0"></a></td>
    </tr>			
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고문서 지출처리예정내역 현금일 때 <font color='red'>최근 출금</font>된 계좌정보</span> (최대10건) </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="4%">연번</td>
                    <td class=title width="13%">자동차사</td>										
                    <td class=title width="18%">영업소명</td>										
                    <td class=title width="10%">금융사</td>
					<td class=title width="8%">계좌구분</td>
                    <td class=title width="18%">계좌번호</td>
                    <td class=title width="20%">예금주</td>
                    <td class=title width="9%">출금일자</td>					
                </tr>
                <%	int count = 0;
					int max_size = 10;
					if(vt_size3>max_size) vt_size3 = max_size;
					for (int i = 0 ; i < vt_size3 ; i++){
    					Hashtable ht = (Hashtable)vt3.elementAt(i);
						if(co_bean.getCar_comp_nm().equals(String.valueOf(ht.get("CAR_COMP_NM")))){%>
                <tr align="center">
                    <td><%=count+1%></td>
                    <td><%=ht.get("CAR_COMP_NM")%></td>		  		  										
                    <td><%=ht.get("CAR_OFF_NM")%></td>		  		  										
                    <td><%=ht.get("BANK")%></td>		  		  
                    <td>
					<%if(String.valueOf(ht.get("ACC_ST")).equals("1")){%>영구계좌
					<%}else if(String.valueOf(ht.get("ACC_ST")).equals("2")){%>가상계좌
					<%}%>
					</td>		  		  					
                    <td><a href="javascript:Disp('<%=ht.get("BANK")%>','<%=ht.get("ACC_NO")%>','<%=ht.get("ACC_NM")%>','<%=ht.get("ACC_ST")%>')" onMouseOver="window.status=''; return true"><%=ht.get("ACC_NO")%></a></td>
                    <td><%=ht.get("ACC_NM")%></td>
                    <td><%=ht.get("BAS_DT")%></td>					
                </tr>
            <%			}
						count++;
					}%>
            </table>
	    </td>
    </tr>	
	<%if(1!=1){%>
	<%	//출고문서 등록 계좌별 그룹 최종사용일 판단
		Vector vt = d_db.getCarPurBrchAccList(t_wd);
		int vt_size = vt.size();%>
    <tr>
        <td class=h></td>
    </tr>				
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고문서 지출처리예정내역 현금일 때 등록된 <font color='red'>계좌정보 이력</font></span> (최종사용일을 확인하여 맞는 계좌를 선택하세요.) </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="4%">연번</td>
					<!--<td class=title width="8%">구분</td>-->
                    <td class=title width="13%">자동차사</td>										
                    <td class=title width="18%">영업소명</td>										
                    <td class=title width="10%">금융사</td>
					<td class=title width="8%">계좌구분</td>
                    <td class=title width="18%">계좌번호</td>
                    <td class=title width="20%">예금주</td>
                    <td class=title width="9%">최종사용일</td>					
                </tr>
                <%	count = 0;
					for (int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);
						if(co_bean.getCar_comp_nm().equals(String.valueOf(ht.get("CAR_COMP_NM")))){%>
                <tr align="center">
                    <td><%=count+1%></td>
                    <!--<td><%=ht.get("ST")%></td>-->
                    <td><%=ht.get("CAR_COMP_NM")%></td>		  		  										
                    <td><%=ht.get("CAR_OFF_NM")%></td>		  		  										
                    <td><%=ht.get("BANK")%></td>		  		  
                    <td>
					<%if(String.valueOf(ht.get("ACC_ST")).equals("1")){%>영구계좌
					<%}else if(String.valueOf(ht.get("ACC_ST")).equals("2")){%>가상계좌
					<%}%>
					</td>		  		  					
                    <td><a href="javascript:Disp('<%=ht.get("BANK")%>','<%=ht.get("ACC_NO")%>','<%=ht.get("ACC_NM")%>','<%=ht.get("ACC_ST")%>')" onMouseOver="window.status=''; return true"><%=ht.get("ACC_NO")%></a></td>
                    <td><%=ht.get("ACC_NM")%></td>
                    <td><%=ht.get("BAS_DT")%></td>					
                </tr>
            <%			}
						count++;
					}%>
            </table>
	    </td>
    </tr>
	<%}%>
    <tr>
        <td>* 계좌구분 : 영구계좌, 가상계좌</td>
    </tr>		
    <tr>
        <td class=h></td>
    </tr>	
    <tr> 
        <td align="center"><a href="javascript:window.close();" class="btn"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>