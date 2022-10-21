<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	Vector clients = al_db.getClientList(s_kd, t_wd, "0");
	int client_size = clients.size();
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>

<body>
<table width="800" border="0" cellspacing="1" cellpadding="0">
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class=line colspan="2"> <table border="0" cellspacing="1" cellpadding='0' width=800>
              <tr> 
                <td class='title' width="100">상호&nbsp; </td>
                <td class='left' colspan="2">&nbsp;(주)대림산업</td>
                <td class=title width="100">계약자</td>
                <td class='left' colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class='title'>사용본거지</td>
                <td class='left' colspan="5">&nbsp;</td>
              </tr>
              <tr> 
                <td class='title'>사업장 주소</td>
                <td class='left' colspan="5">&nbsp;</td>
              </tr>
              <tr> 
                <td class='title'>회사전화번호</td>
                <td class='left' width="148">&nbsp;</td>
                <td class='title' width="100">휴대폰</td>
                <td class='left' width="99">&nbsp;</td>
                <td class='title' width="100">자택전화번호</td>
                <td class='left'>&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td colspan="2">&lt; 계약리스트 &gt;</td>
        </tr>
        <tr> 
          <td class=line colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td width='30' class='title'>연번</td>
                <td width='80' class='title'>계약일</td>
                <td class='title' width="100" >차량번호</td>
                <td width='80' class='title'>차종</td>
                <td width='80' class='title'>최초등록일</td>
                <td width='70' class='title'>대여상품</td>
                <td width='70' class='title'>대여기간</td>
                <td width='80' class='title'>대여개시일</td>
                <td width='80' class='title'>계약만료일</td>
                <td width='70' class='title'>영업담당</td>
                <td width='70' class='title'>관리담당</td>
              </tr>
              <tr> 
                <td align='center'>1</td>
                <td align='center'>2001-01-27</td>
                <td align='center'><span title='서울34허6212'>서울34허6212</span></td>
                <td align='center'>테라칸</td>
                <td align='center'>2002-10-29</td>
                <td align='center'>렌트 일반식</td>
                <td align='center'>36개월</td>
                <td align='center'>2001-02-09</td>
                <td align='center'>2004-02-08</td>
                <td align='center'>조성희</td>
                <td align='center'>오성호</td>
              </tr>
              <tr> 
                <td align='center'>2</td>
                <td align='center'>2001-02-16</td>
                <td width='-2' align='center'><span title='서울34허6158'>서울34허6158</span></td>
                <td align='center'>테라칸</td>
                <td align='center'>2002-01-21</td>
                <td align='center'>렌트 일반식</td>
                <td align='center'>36개월</td>
                <td align='center'>2004-04-01</td>
                <td align='center'>2004-12-31</td>
                <td align='center'>조성희</td>
                <td align='center'>이광희</td>
              </tr>
              <tr> 
                <td align='center'>3</td>
                <td align='center'>2001-03-19</td>
                <td width='-2' align='center'><span title='서울31허8064'>서울31허8064</span></td>
                <td align='center'>테라칸</td>
                <td align='center'>2001-04-09</td>
                <td align='center'>렌트 일반식</td>
                <td align='center'>36개월</td>
                <td align='center'>2001-04-09</td>
                <td align='center'>2004-04-08</td>
                <td align='center'>조성희</td>
                <td align='center'>김욱</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td>&lt; 거래처방문 스케줄 &gt; </td>
          <td align="right">
            <!--<font color="#666666"> ♣ <a href="javascript:MM_openBrWindow('client_loop2.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=600,height=600,top=50,left=50')">거래처방문주기</a> 
              : <font color="#FF0000">한달</font></font>-->
          </td>
        </tr>
        <tr> 
          <td class=line colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td class='title' width='80'>관리담당자</td>
                <td width="120">&nbsp;강주원</td>
                <td class='title' width="80">최초방문일자</td>
                <td width="120">&nbsp; <input type="text" name="t_wd323" size="10" class=text value="2004-01-01"> 
                </td>
                <td class='title' width="80">방문주기</td>
                <td width="120">&nbsp; <input type="text" name="t_wd32332" size="2" class=text value="1">
                  개월 
                  <input type="text" name="t_wd323322" size="2" class=text value="0">
                  일</td>
                <td class='title' width="80">방문횟수</td>
                <td width="120">&nbsp; <input type="text" name="t_wd3233" size="3" class=text value="36">
                  회</td>
              </tr>
            </table></td>
        </tr>
        <tr align="right"> 
          <td colspan="2"><font color="#666666"><a href="#">방문예정일 변경</a>||<a href="#">스케줄추가생성</a>||<a href="#">거래처방문 
            스케줄생성</a></font></td>
        </tr>
        <tr> 
          <td class=line colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td class='title' width='29'>회차</td>
                <td class='title' width="100">다음방문예정일</td>
                <td class='title' width="78">방문일자</td>
                <td class='title' width="59">방문자</td>
                <td class='title' width="98">방문목적</td>
                <td class='title' width="98">상담자</td>
                <td class='title' width="246">상담내용</td>
                <td class='title' width="39">등록</td>
                <td class='title' width="43">삭제</td>
              </tr>
              <tr> 
                <td align='center'>1</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 강주원</td>
                <td align="center">&nbsp; 순회방문</td>
                <td align="center">홍길동</td>
                <td>정기방문</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">U</a></td>
                <td align="center"><a href="#">D</a></td>
              </tr>
              <tr> 
                <td align='center'>2</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 강주원</td>
                <td align="center">&nbsp; 계약상담</td>
                <td align="center">홍길동</td>
                <td>증차예정</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">U</a></td>
                <td align="center"><a href="#">D</a></td>
              </tr>
              <tr> 
                <td align='center'>3</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 강주원</td>
                <td align="center">&nbsp; 연체</td>
                <td align="center">홍길동</td>
                <td>대여료 입금 독촉</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">U</a></td>
                <td align="center"><a href="#">D</a></td>
              </tr>
              <tr> 
                <td align='center'>4</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 강주원</td>
                <td align="center">&nbsp; 계약조건변경</td>
                <td align="center">홍길동</td>
                <td>계약연장</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">U</a></td>
                <td align="center"><a href="#">D</a></td>
              </tr>
              <tr> 
                <td align='center'>5</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 강주원</td>
                <td align="center">&nbsp; 기타</td>
                <td align="center">홍길동</td>
                <td>&nbsp;</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">U</a></td>
                <td align="center"><a href="#">D</a></td>
              </tr>
              <tr> 
                <td align='center'>6</td>
                <td align="center"> 2004-01-01</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td>&nbsp;</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">R</a></td>
                <td align="center">-</td>
              </tr>
              <tr> 
                <td align='center'>7</td>
                <td align="center"> 2004-01-01</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td>&nbsp;</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">R</a></td>
                <td align="center">-</td>
              </tr>
              <tr> 
                <td align='center'>8</td>
                <td align="center"> 2004-01-01</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td>&nbsp;</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">R</a></td>
                <td align="center">-</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td align="center" colspan="2"><a href="car_serv_reg2.htm">거래처방문 등록 
            후 자동차정비로 이동</a></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
