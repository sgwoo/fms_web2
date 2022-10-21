<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.condition.*"%>
<%@ page import="acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%

	ConditionDatabase cdb = ConditionDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();

//	String ref_dt1 = Util.getDate();
//	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	
	String g_fm = "1";
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String ch_bank_id = request.getParameter("r_bank_id")==null?"":request.getParameter("r_bank_id");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String st_dt = request.getParameter("st_dt")==null?Util.getDate():request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?Util.getDate():request.getParameter("end_dt");
	
//	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
//	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	Vector vt = cdb.getLoanCondAll(dt, st_dt, end_dt, gubun2, gubun3, gubun4, "1");
	int vt_size = vt.size();
	
	float loan_amt = 0;
	int loan_amt1 = 0;
	
	float loan_a_amt = 0;
	float loan_b_amt = 0;
	
	int loan_a_amt1 = 0;
	int loan_b_amt1 = 0;
		
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "cho_id"){		
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='r_bank_id' value='<%=ch_bank_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=4%>연번</td>
                    <td class='title' width=4%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                    <td width=13% class='title'>상호</td>
                    <td width=5% class='title'>기간(월)</td>
                    <td width=6% class='title'>월대여료</td>
                    <td width=8% class='title'>총대여료</td>
                    <td width=8% class='title'>출고예정일</td>
					<td width=8% class='title'>취득세</td>
                    <td width=10% class='title'>계출번호</td>
                    <td width=11% class='title'>차종</td>
                    <td width=9% class='title'>차량번호</td>
                    <td width=7% class='title'>구입가격</td>
                    <td width=7% class='title'>대출금액</td>
        
                </tr>
          <% 		for (int i = 0 ; i < vt_size ; i++){
			Hashtable loan = (Hashtable)vt.elementAt(i);		
			// 추후 데이타 화 
			 if (ch_bank_id.equals("0038")) { //롯데캐피탈
			    loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;
			} else if (ch_bank_id.equals("0009") || ch_bank_id.equals("0005") || ch_bank_id.equals("0001") || ch_bank_id.equals("0003") ) { //신한캐피탈 or 신한은행 or 하나은행 or 우리은행
			    loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;
			} else if (ch_bank_id.equals("0040")) { //외환캐피탈
				loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;
			} else if (ch_bank_id.equals("0010")) { //산은캐피탈
					loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;
		    } else if (ch_bank_id.equals("0039")) { //효성캐피탈
				 loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;
		    } else {
		         loan_amt =  0;
		   	}
			

			loan_amt1 = (int) loan_amt;
			loan_amt1 = AddUtil.ten_th_rnd(loan_amt1);
			
			/* if (ch_bank_id.equals("0038") || ch_bank_id.equals("0040") || ch_bank_id.equals("0039") || ch_bank_id.equals("0051")   || ch_bank_id.equals("0057")  || ch_bank_id.equals("0059")  
					|| ch_bank_id.equals("0058")   || ch_bank_id.equals("0060")   || ch_bank_id.equals("0028")    || ch_bank_id.equals("0068")   || ch_bank_id.equals("0069")   
					|| ch_bank_id.equals("0072")  || ch_bank_id.equals("0073")    || ch_bank_id.equals("0074")   || ch_bank_id.equals("0076")    || ch_bank_id.equals("0077")   
					|| ch_bank_id.equals("0078")  || ch_bank_id.equals("0081") || ch_bank_id.equals("0083")  || ch_bank_id.equals("0084")  || ch_bank_id.equals("0085")  || ch_bank_id.equals("0088") 
					|| ch_bank_id.equals("0089") || ch_bank_id.equals("0090") || ch_bank_id.equals("0092") || ch_bank_id.equals("0094") ) { 
			         loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;
			} else if (ch_bank_id.equals("0009") || ch_bank_id.equals("0005") || ch_bank_id.equals("0001") || ch_bank_id.equals("0003")  ) { //신한캐피탈 or 신한은행 or 하나은행 or 우리은행 
				loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;
			} else if (ch_bank_id.equals("0010") ||  ch_bank_id.equals("0055")   || ch_bank_id.equals("0064")  || ch_bank_id.equals("0065") ||  ch_bank_id.equals("0075")  || ch_bank_id.equals("0079") || ch_bank_id.equals("0080")|| ch_bank_id.equals("0082")   ||  ch_bank_id.equals("0086")   ||  ch_bank_id.equals("0087")  ||  ch_bank_id.equals("0091")  ||  ch_bank_id.equals("0093")    ) { //산은캐피탈 , BS캐피탈, 메리츠, 한화생명보험, 농심캐피탈 , 메리츠캐피탈(0079) , ok저축(0080), 대신저축(0082) , orix , 오케이아프로(0087), 동부캐피탈(0091), 롯데오토리스(0093)
				loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) /  AddUtil.parseFloat("1.1");
			} else if (ch_bank_id.equals("0043") || ch_bank_id.equals("0044") || ch_bank_id.equals("0041") ||  ch_bank_id.equals("0002")  ||  ch_bank_id.equals("0063")      ) { //두산캐피탈, nh캐피탈 , 하나캐피탈 , 외환은행, DGB캐피탈, 메리츠 , 
				loan_a_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) - (AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT")))*10/100 ); 
			         loan_a_amt1 = (int) loan_a_amt;
		            	loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1);	
		     
		         } else if (ch_bank_id.equals("0018") || ch_bank_id.equals("0037")) { //삼성카드 :20160318 80->90%, 산업은행(0037) 20160712
		            	loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;	    
		         } else if (ch_bank_id.equals("0026")  ) { //대구은행 공급가만 대출
		                  loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_S_AMT"))) * 100/100;                  
		         } else if (ch_bank_id.equals("0004")  ||  ch_bank_id.equals("0025")   ) { //국민은행  ,  부산은행   	
		                  loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_S_AMT"))) * 90/100;                          
		       //  	} else if ( ch_bank_id.equals("0037")   ) { //산업은행
				//loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) /  AddUtil.parseFloat("1.1") *  80/100;	      
		      	} else if ( ch_bank_id.equals("0029")  ||  ch_bank_id.equals("0033")  ) { //광주은행	, 전북은행  
				loan_a_amt =  AddUtil.parseFloat(String.valueOf(loan.get("CAR_S_AMT"))) * 100/100;
				loan_a_amt1 = (int) loan_a_amt;
		            	loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1); 		
			} else if ( ch_bank_id.equals("0011") ) { //현대캐피탈 구입가격 대출
				loan_a_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) ;	     
				loan_a_amt1 = (int) loan_a_amt;
		            	loan_a_amt1 = AddUtil.ml_th_rnd(loan_a_amt1); 		
		         	} else if ( ch_bank_id.equals("0056") ) { //kt구입가격 대출
				loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) ;	     	           	  	
		          } else {
		                  loan_amt =  0;
		   	}
			
			
			loan_amt1 = (int) loan_amt;
			
			if (ch_bank_id.equals("0043") || ch_bank_id.equals("0044") || ch_bank_id.equals("0041") || ch_bank_id.equals("0002") || ch_bank_id.equals("0011")  || ch_bank_id.equals("0063")   || ch_bank_id.equals("0029")   || ch_bank_id.equals("0033")    || ch_bank_id.equals("0086")    ) {
				loan_amt1 = loan_a_amt1;
			} else if (ch_bank_id.equals("0026")  ) { 
				loan_amt1 = loan_amt1;
			} else if (ch_bank_id.equals("0018") ) { 
				loan_amt1 = AddUtil.th_rnd(loan_amt1);
		//	} else if (ch_bank_id.equals("0037") ) { 
		//		loan_amt1 = AddUtil.hun_th_rnd(loan_amt1);
			} else {
				loan_amt1 = AddUtil.ten_th_rnd(loan_amt1);
		        }  */
			
		  %>	  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td> 
                      <input type="checkbox" name="cho_id" value="<%=loan.get("RENT_MNG_ID")%>^<%=loan.get("RENT_L_CD")%>^<%=loan.get("CAR_MNG_ID")%>^<%=ch_bank_id%>^">
                    </td>
                    <td><span title='<%=loan.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(loan.get("FIRM_NM")), 7)%></td>
                    <td><%=loan.get("CON_MON")%></td>
                    <td align=right><%=Util.parseDecimal(loan.get("FEE_AMT"))%>&nbsp;</td>
                    <td align=right><%=Util.parseDecimal(loan.get("TOT_FEE_AMT"))%>&nbsp;</td>
                    <td align=center><%=loan.get("DLV_EST_DT")%></td>
					<td><%=Util.subData(c_db.getNameById(String.valueOf(loan.get("CPT_CD")),"BANK"), 6)%></td>
                    <td><%=loan.get("RPT_NO")%></td>
                    <td><%=Util.subData(String.valueOf(loan.get("CAR_NM")), 7)%></td>
                    <td><%=loan.get("CAR_NO")%></td>
                    <td align=right><%=Util.parseDecimal(loan.get("CAR_AMT"))%>&nbsp;</td>
                    <td align=right><%=Util.parseDecimal(loan_amt1)%>&nbsp;</td>
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
