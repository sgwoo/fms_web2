<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*,acar.fax_word.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	//사용자별 정보 조회 및 수정 페이지
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
		
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String br_id = "";
	String br_nm = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String user_ssn1 = "";
	String user_ssn2 = "";
	String dept_id = "";
	String dept_nm = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_email = "";
	String user_pos = "";
	String lic_no = "";
	String lic_dt = "";
	String enter_dt = "";
	String user_zip = "";
	String user_addr = "";
	String content = "";
	String filename = "";
	String user_aut2 = "";
	String user_work = "";
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	br_id 		= user_bean.getBr_id();
	br_nm 		= user_bean.getBr_nm();
	user_nm 	= user_bean.getUser_nm();
	id 			= user_bean.getId();
	user_psd 	= user_bean.getUser_psd();
	user_cd 	= user_bean.getUser_cd();
	user_ssn 	= user_bean.getUser_ssn();
	user_ssn1 	= user_bean.getUser_ssn1();
	user_ssn2 	= user_bean.getUser_ssn2();
	dept_id 	= user_bean.getDept_id();
	dept_nm 	= user_bean.getDept_nm();
	user_h_tel 	= user_bean.getUser_h_tel();
	user_m_tel 	= user_bean.getUser_m_tel();
	user_email 	= user_bean.getUser_email();
	user_pos 	= user_bean.getUser_pos();
	user_aut2 	= user_bean.getUser_aut();
	lic_no 		= user_bean.getLic_no();
	lic_dt 		= user_bean.getLic_dt();
	enter_dt 	= user_bean.getEnter_dt();
	content 	= user_bean.getContent();
	filename 	= user_bean.getFilename();
	user_work 	= user_bean.getUser_work();
	String i_fax =  user_bean.getI_fax();
	String hot_tel =  user_bean.getHot_tel();
	
	//본사-영업소
	Hashtable br1 = c_db.getBranch(br_id);
	
	String br_addr 	= String.valueOf(br1.get("BR_ADDR"));
	String br_tel 	= String.valueOf(br1.get("TEL"));
	String br_fax 	= String.valueOf(br1.get("FAX"));
	
	if(dept_nm.equals("고객지원팀")){
		br_tel = "02-392-4242";
		br_fax = "02-3775-4243";
	}
	if(dept_nm.equals("총무팀")){
		br_tel = "02-392-4243";
	}
	
	if(!i_fax.equals("")) 	br_fax = i_fax;
	if(!hot_tel.equals("")) br_tel = hot_tel;
	
	//은행계좌번호
	Fax_wordDatabase f_db = Fax_wordDatabase.getInstance();
	Vector fax = f_db.Fax_word_list(user_id);
	int fax_size = fax.size();
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>FAX커버</title>
<style type=text/css>
<!--
.style1 {font-size: 11px}
.style2 {font-size: 12px; font-weight: bold;}
-->
</style>
<script language='javascript'>
<!--
function PopFax(cmd)
{
	var fm = document.form1;
	
	sd=new Array();
    sd=fm.memo.innerHTML.split("\r\n");
	if(sd.length > 20){ alert('메모는 20줄까지만 입력하십시오.'); return;}	
	
	window.open("about:blank", "FaxCover", "left=10, top=10, height=700, width=700, scrollbars=yes, status=yes");	
	
	fm.cmd.value = cmd;	
	fm.target = 'FaxCover';
 	fm.action="fax_cover_view.jsp";	
	fm.submit();
}

function PopFax1(cmd)
{
	var fm = document.form1;
	
	sd=new Array();
    sd=fm.memo.innerHTML.split("\r\n");
	if(sd.length > 20){ alert('메모는 20줄까지만 입력하십시오.'); return;}	
	
	window.open("about:blank", "FaxCover", "left=10, top=10, height=700, width=700, scrollbars=yes, status=yes");	
	
	fm.cmd.value = cmd;	
	fm.target = 'FaxCover';
 	fm.action="fax_cover_view_s.jsp";	
	fm.submit();
}

function fax_word_reg(){
		var SUBWIN="fax_word_reg.jsp";	
		window.open(SUBWIN, "fax_word_reg", "left=100, top=100, width=650, height=700, scrollbars=no");
}

function msgDisp(){
		var fm = document.form1;
		fm.memo.value = fm.memo.value+' '+fm.content.value+ "\n\r" ;
//		checklen();
}

 function ok1(){
	var fm = document.form1;
	var j = 0;

		for(i=0; i<fm.gubi1.length; i++){
			if(fm.gubi1[i].checked){
				j++;
				fm.memo.value = fm.memo.value+''+j+'.'+fm.gubi1[i].value+ "\n\r" ;
			}
		}
	}
function ok2(){
 	 var fm = document.form1;
 	 var j = 0;
    for(i=0; i<fm.gubi2.length; i++)
    {
     if(fm.gubi2[i].checked == true)
     {j++;
     	 fm.memo.value = fm.memo.value+''+j+'.'+fm.gubi2[i].value+ "\n\r" ;
     	 
     }
    }
   }
function ok3(){
 	 var fm = document.form1;
 	 var j = 0;
    for(i=0; i<fm.gubi3.length; i++)
    {
     if(fm.gubi3[i].checked == true)
     {j++;
     	 fm.memo.value = fm.memo.value+''+j+'.'+fm.gubi3[i].value+ "\n\r" ;
     }
    }
   }
//textarea 줄수제한
function check_mygreet() 
{ 

var temp; 
var f = form1.memo.value.length; 
var tmpstr = ""; 
var enter = 0; 
var strlen; 

  for(k=0;k<f;k++) 
  { 
  temp = form1.memo.value.charAt(k); 
  
  if(temp == '\n')// 입력 라인 제한을 위해 엔터키 횟수 증가 
  { 
    enter++; 
  } 

  if(enter >= 20) 
  { 
    alert("입력 초과!\n 20줄 이상 입력하실 수 없습니다."); 
    enter = 0; 
    strlen = tmpstr.length - 1; 
    form1.memo.value = tmpstr.substring(0,strlen); 
    break; 
  } 
  else 
  { 
    tmpstr += temp; 
  } 
  } 
} 

var checkflag = "false";
	
	function AllSelect(field){
		if(checkflag == "false"){
			for(i=0; i<field.length; i++){
				field[i].checked = true;
			}
			checkflag = "true";
			return;
		}else{
			for(i=0; i<field.length; i++){
				field[i].checked = false;
			}
			checkflag = "false";
			return;
		}
	}
//-->
</script>

<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>
<center>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<table width=595 border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td height=20></td>
    </tr>
    <tr>
        <td><img src=/fms2/off_doc/images/fax_1.gif width=595 height=34></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td align=right>
            <table width=400 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=18 align=right><%=br_addr%></td>
                </tr>
                <tr>
                    <td height=18 align=right>TEL. <%=br_tel%> | FAX. <%=br_fax%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>
    <tr>
        <td>
            <table width=595 border=0 cellpadding=0 cellspacing=2 bgcolor=#000000>
                <tr>
                    <td bgcolor=#FFFFFF>
                        <table width=591 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=78 height=30 align=center bgcolor=dadada><span class=style2>수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신</span></td>
                                <td width=217 bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=s_com_nm type=text size=31></td>
                                <td width=1 bgcolor=#000000></td>
                                <td width=78 align=center bgcolor=dadada><span class=style2>발&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신</span></td>
                                <td width=217 bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=b_com_nm type=text size=31 value="(주)아마존카"></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style2>담&nbsp;당&nbsp;자</span></td>
                                <td bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=s_agnt_nm type=text size=31></td>
                                <td width=1 bgcolor=#000000></td>
                                <td align=center bgcolor=dadada><span class=style2>담&nbsp;당&nbsp;자</span></td>
                                <td bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=b_agnt_nm type=text size=31 value="<%=user_nm%>"></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style2>전화번호</span></td>
                                <td bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=s_tel type=text size=31></td>
                                <td width=1 bgcolor=#000000></td>
                                <td align=center bgcolor=dadada><span class=style2>전화번호</span></td>
                                <td bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=b_tel type=text size=31 value="<%=hot_tel%>/<%=user_m_tel%>"></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style2>팩스번호</span></td>
                                <td bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=s_fax type=text size=31></td>
                                <td width=1 bgcolor=#000000></td>
                                <td align=center bgcolor=dadada><span class=style2>팩스번호</span></td>
                                <td bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=b_fax type=text size=31 value="<%=br_fax%>"></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style2>총&nbsp;매&nbsp;수</span></td>
                                <td colspan=5 bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=cnt type=text size=3> 매 (표지포함) </td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style2>일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자</span></td>
                                <td colspan=5 bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=dt type=text size=31 value="<%=AddUtil.getDate3()%>"></td>
                            </tr>
    						 <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
    						<tr>
                                <td height=30 align=center bgcolor=dadada><span class=style2>제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</span></td>
                                <td colspan=5 bgcolor=#FFFFFF>&nbsp;&nbsp;<b><input name=title type=text size=81></b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
    							<td height=30 align=center bgcolor=dadada><span class=style2>상용문구</span></td>
                                <td colspan=5 bgcolor=#FFFFFF>&nbsp;&nbsp;<select name='content' onchange="javascript:msgDisp();">
		                        <option value=''>문구를 선택하세요</option>
							    <%	if(fax_size > 0){
										for(int i = 0 ; i < fax_size ; i++){
											Hashtable faxs = (Hashtable)fax.elementAt(i);%>
								<option value='<%= faxs.get("CONTENT")%>'><span title='<%=faxs.get("CONTENT")%>'><%=AddUtil.subData(String.valueOf(faxs.get("CONTENT")), 45)%></span></option>
					            <%		}
									}%>

		                      </select>
                      	  &nbsp;<a href='javascript:fax_word_reg()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                            </tr>
    						<tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                      	  </table>
                   	  	</td>
           	  		  </tr>
						<tr>
                    		<td bgcolor=#FFFFFF>
                        		<table width=591 border=0 cellpadding=0 cellspacing=0 >
                           	        <tr>
                                   		  <td height=30 width=207 bgcolor=dadada><span class=style2><input type="checkbox" name="all_pr" value="Y" onclick='javascript:AllSelect(this.form.gubi1)'> 법인 구비서류</span></td>
                                   		  <td width=1 bgcolor=#000000></td>
                                   		  <td height=30 width=175 bgcolor=dadada><span class=style2><input type="checkbox" name="all_pr" value="Y" onclick='javascript:AllSelect(this.form.gubi2)'> 개인사업자 구비서류</span></td>
                                   		  <td width=1 bgcolor=#000000></td>
                                   		  <td height=30 width=205 bgcolor=dadada><span class=style2><input type="checkbox" name="all_pr" value="Y" onclick='javascript:AllSelect(this.form.gubi3)'> 개인 구비서류</span></td>
                                    </tr>
                                    <tr>
                                        <td colspan=5 height=1 bgcolor=#000000></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor=#FFFFFF><span class=style1>
                                          <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_1 value="사업자등록증사본"> 사업자등록증사본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_2 value="법인등기부등본"> 법인등기부등본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_3 value="법인인감증명서"> 법인인감증명서<br>
                                          <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_4 value="대표자신분증사본"> 대표자신분증사본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_5 value="대표자인감증명서"> 대표자인감증명서<br>
                                          <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_6 value="대표자주민등록등본"> 대표자주민등록등본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_7 value="자동이체통장사본"> 자동이체통장사본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_8 value="주운전자면허증사본"> 주운전자면허증사본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_9 value="재무제표(대차대조표,손익계산서)"> 재무제표(대차대조표,손익계산서)<br>
                                  		  <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_10 value="명판"> 명판<br>
		                                  <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_11 value="법인인감도장"> 법인인감도장<br>
		                                  <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_12 value="대표이사 인감도장"> 대표이사 인감도장<br>
		                                  <INPUT TYPE="checkbox" NAME=gubi1 id=gubi1_13 value="통장도장"> 통장도장
                                  </span>                                   		  
                                        </td>
                                        <td width=1 bgcolor=#000000></td>
        							    <td bgcolor=#FFFFFF valign="top"><span class=style1>
        								  <INPUT TYPE="checkbox" NAME=gubi2 id=gubi2_1 value="사업자등록증사본"> 사업자등록증사본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi2 id=gubi2_2 value="대표자 신분증사본"> 대표자 신분증사본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi2 id=gubi2_3 value="대표자 인감증명서"> 대표자 인감증명서<br>
                                          <INPUT TYPE="checkbox" NAME=gubi2 id=gubi2_4 value="대표자주민등록등본"> 대표자주민등록등본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi2 id=gubi2_5 value="자동이체 통장사본"> 자동이체 통장사본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi2 id=gubi2_6 value="매출증빙자료"> 매출증빙자료<br>
                                          <INPUT TYPE="checkbox" NAME=gubi2 id=gubi2_7 value="주운전자면허증사본"> 주운전자면허증사본<br>
                                  		  <INPUT TYPE="checkbox" NAME=gubi2 id=gubi2_8 value="명판"> 명판<br>
		                                  <INPUT TYPE="checkbox" NAME=gubi2 id=gubi2_9 value="대표이사 인감도장"> 대표이사 인감도장<br>
		                                  <INPUT TYPE="checkbox" NAME=gubi2 id=gubi2_10 value="통장도장"> 통장도장
                                  </span>
                                          
        								</td>
        								<td width=1 bgcolor=#000000></td>
        								<td bgcolor=#FFFFFF valign="top"><span class=style1>
        								  <INPUT TYPE="checkbox" NAME=gubi3 id=gubi3_1 value="신분증사본"> 신분증사본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi3 id=gubi3_2 value="주민등록등본"> 주민등록등본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi3 id=gubi3_3 value="인감증명서"> 인감증명서<br>
                                          <INPUT TYPE="checkbox" NAME=gubi3 id=gubi3_4 value="자동이체 통장사본"> 자동이체 통장사본<br>
                                          <INPUT TYPE="checkbox" NAME=gubi3 id=gubi3_5 value="재직증명서"> 재직증명서<br>
                                          <INPUT TYPE="checkbox" NAME=gubi3 id=gubi3_6 value="소득증빙자료(원천징수영수증등)"> 소득증빙자료(원천징수영수증등)<br>
                                          <INPUT TYPE="checkbox" NAME=gubi3 id=gubi3_7 value="면허증사본(필요시제출)"> 면허증사본(필요시제출)<br>
                                          <INPUT TYPE="checkbox" NAME=gubi3 id=gubi3_8 value="인감도장"> 인감도장<br>
		                                  <INPUT TYPE="checkbox" NAME=gubi3 id=gubi3_9 value="통장도장"> 통장도장
                                            </span>
                                          
                              	  		</td>
                                    </tr>
                                    <tr>
                                        <td colspan=5 height=1 bgcolor=#000000></td>
                                    </tr>
        							<tr>
        								  <td height=30 align=center bgcolor=dadada><input type="button" onClick="ok1();" value="법인사업자서류삽입"></td>
        								  <td width=1 bgcolor=#000000></td>
        								  <td height=30 align=center bgcolor=dadada><input type="button" onClick="ok2();" value="개인사업자서류삽입"></td>
        								  <td width=1 bgcolor=#000000></td>
        								  <td height=30 align=center bgcolor=dadada><input type="button" onClick="ok3();" value="개인서류삽입"></td>
        						  	</tr>
                                    <tr>
                                        <td colspan=5 height=1 bgcolor=#000000></td>
                                    </tr>
                            
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
    </tr>
    <tr>
        <td height=25></td>
    </tr>
    <tr>
        <td height=379 valign=top background=/fms2/off_doc/images/fax_2.gif>
            <table width=595 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=60 colspan=3></td>
                </tr>
                <tr>
                    <td align=center valign=top><textarea name=memo cols=86 rows=19 onKeyUp="javascript:check_mygreet();" ></textarea></td>
                </tr>
                <tr>
                    <td height=30 colspan=3></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 align=center><span class=style1>* 상기 팩스내용에 대해 문의사항이 있으시면 발신자에게 연락주시기 바랍니다.</span></td>
    </tr>
    <tr>
        <td height=20></td>
    </tr>
    <tr>
        <td align=center><a href="javascript:PopFax('view')"><img src=/fms2/off_doc/images/button_see.gif border=0></a>
		&nbsp;&nbsp;&nbsp;<a href="javascript:PopFax('print')"><img src=/fms2/off_doc/images/button_print.gif border=0></a>&nbsp;&nbsp;<a href="javascript:PopFax1('print')">.</a></td>
    </tr>
    <tr>
        <td height=20></td>
    </tr>	
    <tr>
        <td height=20><span class=style1>* 프린트시 인터넷 익스플로어 화면 상단에 메뉴 설정하세요.----------------------------------------</span></td>
    </tr>	
    <tr>
        <td height=20><span class=style1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. '파일>페이지설정>여백(밀리미터)' 상하좌우 20이 최적입니다.</span></td>
    </tr>	
    <tr>
        <td height=20><span class=style1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. '도구>인터넷옵션>고급(상단맨우측)>인쇄>배경색 및 이미지 인쇄'가 체크 되어 있어야 올바르게 인쇄됩니다.</span></td>
    </tr>	
	<tr>
        <td height=20><span class=style1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. '20줄 이상은 페이지가 넘어가니 확인하시기 바랍니다.'</span></td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</center>
</body>
</html>